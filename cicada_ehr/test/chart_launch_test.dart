import 'dart:convert';

import 'package:cicada/cicada.dart';
import 'package:cicada_ehr/cicada_ehr.dart';
import 'package:fhir_auth_core/fhir_auth_core.dart';
import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

const _base = 'https://ehr.example/fhir';
const _epic = 'https://fhir.epic.com/interconnect-fhir-oauth/api/FHIR/R4';

http.Response _json(Object body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/fhir+json'},
);

Map<String, dynamic> _bundle(
  List<Map<String, dynamic>> entries, {
  String? next,
}) => {
  'resourceType': 'Bundle',
  'type': 'searchset',
  if (next != null)
    'link': [
      {'relation': 'next', 'url': next},
    ],
  'entry': entries,
};

Map<String, dynamic> _match(Map<String, dynamic> resource) => {
  'resource': resource,
  'search': {'mode': 'match'},
};

Map<String, dynamic> _immunization(String id, String cvx, String date) => {
  'resourceType': 'Immunization',
  'id': id,
  'status': 'completed',
  'vaccineCode': {
    'coding': [
      {'system': 'http://hl7.org/fhir/sid/cvx', 'code': cvx},
    ],
  },
  'patient': {'reference': 'Patient/p1'},
  'occurrenceDateTime': date,
};

const _patient = {
  'resourceType': 'Patient',
  'id': 'p1',
  'gender': 'female',
  'birthDate': '2025-01-15',
};

/// A server holding one patient with three immunizations split over two
/// pages, an OperationOutcome note in the first page, and nothing else.
MockClient _server(List<Uri> asked) => MockClient((request) async {
  asked.add(request.url);
  final url = request.url;
  if (url.path == '/fhir/Patient/p1') return _json(_patient);
  if (url.path == '/fhir/Immunization' && url.queryParameters['page'] == null) {
    return _json(
      _bundle([
        _match(_immunization('i1', '08', '2025-01-15')),
        _match(_immunization('i2', '08', '2025-03-15')),
        {
          'resource': {
            'resourceType': 'OperationOutcome',
            'issue': [
              {'severity': 'information', 'code': 'informational'},
            ],
          },
          'search': {'mode': 'outcome'},
        },
      ], next: '$_base/Immunization?patient=p1&page=2'),
    );
  }
  if (url.path == '/fhir/Immunization') {
    return _json(_bundle([_match(_immunization('i3', '08', '2025-07-15'))]));
  }
  if (url.path == '/fhir/Observation') {
    // The same pregnancy-status Observation, whichever category is asked.
    return _json(
      _bundle([
        _match({
          'resourceType': 'Observation',
          'id': 'o1',
          'status': 'final',
          'code': {
            'coding': [
              {'system': 'http://loinc.org', 'code': '82810-3'},
            ],
          },
          'subject': {'reference': 'Patient/p1'},
        }),
      ]),
    );
  }
  return _json(_bundle([]));
});

class _FakeWindow implements BrowserWindow {
  _FakeWindow(this.location);

  @override
  Uri location;

  Uri? assigned;

  @override
  final KeyValueStore sessionStorage = MemoryKeyValueStore();

  @override
  void assign(Uri url) => assigned = url;

  @override
  void replaceUrl(Uri url) => location = url;
}

void main() {
  group('ChartReader', () {
    test('follows next links and keeps only the searched type', () async {
      final asked = <Uri>[];
      final read = await ChartReader(
        client: _server(asked),
        fhirBase: Uri.parse(_base),
      ).read(patientId: 'p1', assessmentDate: DateTime(2026, 11, 19));

      final immunizations = read.parameters.parameter!
          .map((p) => p.resource)
          .whereType<Immunization>()
          .map((i) => i.id!.valueString)
          .toList();
      expect(immunizations, ['i1', 'i2', 'i3']);
      expect(
        read.parameters.parameter!
            .map((p) => p.resource)
            .whereType<OperationOutcome>(),
        isEmpty,
      );
      expect(read.patient.id!.valueString, 'p1');
      final immunizationReport = read.reports.singleWhere(
        (r) => r.search == 'Immunization',
      );
      expect(immunizationReport.pages, 2);
      expect(immunizationReport.kept, 3);
      // One read of the Patient, two Immunization pages, one page for
      // each other search.
      expect(asked, hasLength(1 + 2 + ChartReader.searches.length - 1));
      for (final (type, query) in ChartReader.searches) {
        expect(
          asked.where(
            (u) =>
                u.path == '/fhir/$type' &&
                u.queryParameters['patient'] == 'p1' &&
                query.entries.every((e) => u.queryParameters[e.key] == e.value),
          ),
          isNotEmpty,
          reason: '$type $query',
        );
      }
    });

    test('an Observation two searches return is sent once', () async {
      final read = await ChartReader(
        client: _server([]),
        fhirBase: Uri.parse(_base),
      ).read(patientId: 'p1', assessmentDate: DateTime(2026, 11, 19));

      final observations = read.parameters.parameter!
          .map((p) => p.resource)
          .whereType<Observation>()
          .toList();
      expect(observations, hasLength(1));
      expect(
        read.reports.where((r) => r.search.startsWith('Observation?')),
        everyElement(
          isA<ChartSearchReport>().having((r) => r.kept, 'kept', 1),
        ),
      );
    });

    test('the engine counts every dose the chart holds', () async {
      final read = await ChartReader(
        client: _server([]),
        fhirBase: Uri.parse(_base),
      ).read(patientId: 'p1', assessmentDate: DateTime(2026, 11, 19));

      final result = evaluateForForecast(read.parameters);
      expect(result.patient.pastDoses, hasLength(3));
    });

    test('a refused search names the type and the server reason', () async {
      final client = MockClient((request) async {
        if (request.url.path.endsWith('/Patient/p1')) return _json(_patient);
        return _json({
          'resourceType': 'OperationOutcome',
          'issue': [
            {
              'severity': 'error',
              'code': 'required',
              'diagnostics': 'A required parameter is missing',
            },
          ],
        }, 400);
      });
      await expectLater(
        ChartReader(
          client: client,
          fhirBase: Uri.parse(_base),
        ).read(patientId: 'p1', assessmentDate: DateTime(2026, 11, 19)),
        throwsA(
          isA<ChartReadException>().having(
            (e) => e.message,
            'message',
            allOf(
              contains('/fhir/Immunization'),
              contains('400'),
              contains('A required parameter is missing'),
            ),
          ),
        ),
      );
    });

    test('a next link that repeats ends the read at once', () async {
      var searches = 0;
      final client = MockClient((request) async {
        if (request.url.path.endsWith('/Patient/p1')) return _json(_patient);
        searches += 1;
        return _json(_bundle([], next: request.url.toString()));
      });
      await expectLater(
        ChartReader(
          client: client,
          fhirBase: Uri.parse(_base),
        ).read(patientId: 'p1', assessmentDate: DateTime(2026, 11, 19)),
        throwsA(isA<ChartReadException>()),
      );
      // The repeat is caught before it is fetched a second time.
      expect(searches, 1);
    });
  });

  group('launchRequestOf', () {
    test('reads the step from the address', () {
      expect(
        launchRequestOf(Uri.parse('http://localhost:8080/')),
        LaunchRequest.none,
      );
      expect(
        launchRequestOf(
          Uri.parse('http://localhost:8080/?iss=$_epic&launch=x'),
        ),
        LaunchRequest.begin,
      );
      expect(
        launchRequestOf(
          Uri.parse('http://localhost:8080/callback.html?code=c&state=s'),
        ),
        LaunchRequest.finish,
      );
    });
  });

  group('EhrSignIn.begin', () {
    test('refuses a server not on the list, before any request', () async {
      final asked = <Uri>[];
      final window = _FakeWindow(
        Uri.parse(
          'http://localhost:8080/?iss=https://evil.example/fhir&launch=x',
        ),
      );
      await expectLater(
        EhrSignIn(
          window: window,
          clientId: 'cicada',
          httpClient: MockClient((r) async {
            asked.add(r.url);
            return http.Response('', 404);
          }),
        ).begin(),
        throwsA(isA<EhrSignInException>()),
      );
      expect(asked, isEmpty);
      expect(window.assigned, isNull);
    });

    test('sends the page to the authorize endpoint with the launch', () async {
      final window = _FakeWindow(
        Uri.parse('http://localhost:8080/?iss=$_epic&launch=abc'),
      );
      await EhrSignIn(
        window: window,
        clientId: 'cicada',
        httpClient: MockClient((r) async {
          if (r.url.path.endsWith('/.well-known/smart-configuration')) {
            return _json({
              'authorization_endpoint':
                  'https://fhir.epic.com/oauth2/authorize',
              'token_endpoint': 'https://fhir.epic.com/oauth2/token',
              'capabilities': ['launch-ehr', 'client-public'],
              'code_challenge_methods_supported': ['S256'],
            });
          }
          return http.Response('', 404);
        }),
      ).begin();

      final sent = window.assigned!;
      expect(sent.path, '/oauth2/authorize');
      expect(sent.queryParameters['launch'], 'abc');
      expect(sent.queryParameters['aud'], _epic);
      expect(sent.queryParameters['scope']!.split(' '), contains('launch'));
      expect(
        sent.queryParameters['redirect_uri'],
        'http://localhost:8080/callback.html',
      );
      expect(sent.queryParameters['code_challenge_method'], 'S256');
    });
  });
}
