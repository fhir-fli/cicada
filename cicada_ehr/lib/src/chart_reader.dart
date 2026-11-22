import 'dart:convert';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:http/http.dart' as http;

/// One search the reader made, for the console report. It holds counts only,
/// never patient data.
class ChartSearchReport {
  const ChartSearchReport({
    required this.search,
    required this.pages,
    required this.kept,
  });

  /// The search, as `Type?param=value` without the patient.
  final String search;

  /// Pages fetched, the first included.
  final int pages;

  /// Resources of the searched type kept from all pages.
  final int kept;

  @override
  String toString() => '$search: $kept kept from $pages page(s)';
}

/// A chart read that could not finish.
class ChartReadException implements Exception {
  const ChartReadException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// What the reader gives the forecast: the engine's input and how it was
/// gathered.
class ChartRead {
  const ChartRead({
    required this.parameters,
    required this.patient,
    required this.reports,
  });

  final Parameters parameters;
  final Patient patient;
  final List<ChartSearchReport> reports;
}

/// Reads one patient's chart from a FHIR R4 server into the `Parameters`
/// the cicada engine takes.
class ChartReader {
  ChartReader({required this.client, required this.fhirBase});

  /// An HTTP client that signs each request (a signed-in `SmartFhirClient`).
  final http.Client client;

  /// The FHIR server's base address.
  final Uri fhirBase;

  /// The searches made besides reading the Patient, each also given the
  /// `patient` (R4B SearchParameter-clinical-patient.json lists all five
  /// types in its `base`). The engine also reads MedicationRequest,
  /// MedicationStatement, MedicationAdministration and ServiceRequest; the
  /// Epic app record grants none of them (scopes granted 2026-11-19).
  ///
  /// Observation is searched by category because Epic refuses an
  /// Observation search with neither: "Must have either code or category"
  /// (Epic sandbox, 400, 2026-11-19). The engine reads laboratory results
  /// (immunity tests) and social history (pregnancy, smoking, occupation),
  /// two codes of R4B CodeSystem-observation-category.json. Observations in
  /// the other seven categories are not read.
  static const List<(String, Map<String, String>)> searches = [
    ('Immunization', {}),
    ('Condition', {}),
    ('AllergyIntolerance', {}),
    ('Observation', {'category': 'laboratory'}),
    ('Observation', {'category': 'social-history'}),
    ('Procedure', {}),
  ];

  /// A guard against a server whose `next` links never end.
  static const int maxPages = 100;

  static const Map<String, String> _accept = {
    'Accept': 'application/fhir+json',
  };

  /// Read the patient [patientId] and the results of every one of
  /// [searches] for them, following each page's `next` link (R4B http.html
  /// 3.1.0.14 Paging, read 2026-11-19: servers that page "SHALL conform to
  /// this method (adapted from RFC 5005 ...) for sending continuation links
  /// to the client").
  Future<ChartRead> read({
    required String patientId,
    required DateTime assessmentDate,
  }) async {
    // The Patient read and the searches do not depend on one another, so
    // they are all sent at once and the chart takes as long as the slowest
    // one rather than the sum. Results are used in [searches] order, so the
    // engine's input is the same as reading them one by one. Each search's
    // own pages still follow one another: a page's `next` link is only
    // known once the page has arrived.
    // Future.wait fails with the first error to arrive, unwrapped, and
    // keeps the others from going unhandled.
    final all = await Future.wait<Object>([
      _getJson(_url('Patient/${Uri.encodeComponent(patientId)}')),
      for (final (type, query) in searches) _search(type, query, patientId),
    ]);
    final patientJson = all.first as Map<String, dynamic>;
    final results = all
        .skip(1)
        .cast<(List<Resource>, ChartSearchReport)>()
        .toList();
    final patient = Resource.fromJson(patientJson);
    if (patient is! Patient) {
      throw ChartReadException(
        'Patient/$patientId answered a ${patient.resourceType}, not a Patient',
      );
    }

    final parameter = <ParametersParameter>[
      ParametersParameter(
        name: 'assessmentDate'.toFhirString,
        valueDate: FhirDate.fromDateTime(assessmentDate),
      ),
      ParametersParameter(name: 'patient'.toFhirString, resource: patient),
    ];
    final reports = <ChartSearchReport>[];
    // A resource two searches both return is sent once.
    final added = <String>{};
    for (var i = 0; i < searches.length; i++) {
      final type = searches[i].$1;
      final (resources, report) = results[i];
      reports.add(report);
      for (final resource in resources) {
        final id = resource.id?.valueString;
        if (id != null && !added.add('$type/$id')) continue;
        parameter.add(
          ParametersParameter(
            name: _parameterName(type).toFhirString,
            resource: resource,
          ),
        );
      }
    }
    return ChartRead(
      parameters: Parameters(parameter: parameter),
      patient: patient,
      reports: reports,
    );
  }

  Future<(List<Resource>, ChartSearchReport)> _search(
    String type,
    Map<String, String> query,
    String patientId,
  ) async {
    final kept = <Resource>[];
    final seen = <String>{};
    final label = query.isEmpty
        ? type
        : '$type?${query.entries.map((e) => '${e.key}=${e.value}').join('&')}';
    Uri? next = _url(
      type,
    ).replace(queryParameters: {'patient': patientId, ...query});
    var pages = 0;
    while (next != null) {
      if (!seen.add(next.toString()) || pages == maxPages) {
        throw ChartReadException(
          '$label search did not end: page ${pages + 1} repeats or passes '
          '$maxPages',
        );
      }
      pages += 1;
      final resource = Resource.fromJson(await _getJson(next));
      if (resource is! Bundle) {
        throw ChartReadException(
          '$type search answered a ${resource.resourceType}, not a Bundle',
        );
      }
      for (final entry in resource.entry ?? const <BundleEntry>[]) {
        final r = entry.resource;
        // A searchset can also carry an OperationOutcome about the search,
        // "marked with a Bundle.entry.search.mode of outcome" (R4B
        // http.html, search, read 2026-11-19). Only the searched type is
        // the chart.
        if (r != null && r.resourceType.toString() == type) kept.add(r);
      }
      final nextLink = resource.link
          ?.where((l) => l.relation.valueString == 'next')
          .firstOrNull;
      next = nextLink?.url.valueString == null
          ? null
          : Uri.parse(nextLink!.url.valueString!);
    }
    return (
      kept,
      ChartSearchReport(
        search: label,
        pages: pages,
        kept: kept.length,
      ),
    );
  }

  Future<Map<String, dynamic>> _getJson(Uri url) async {
    final response = await client.get(url, headers: _accept);
    if (response.statusCode != 200) {
      throw ChartReadException(
        'GET ${url.path} answered ${response.statusCode}: '
        '${_issueText(response.body)}',
      );
    }
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic>) {
      throw ChartReadException('GET ${url.path} answered no JSON object');
    }
    return body;
  }

  /// The diagnostics of an OperationOutcome body, or nothing.
  static String _issueText(String body) {
    try {
      final outcome = Resource.fromJson(
        jsonDecode(body) as Map<String, dynamic>,
      );
      if (outcome is OperationOutcome) {
        return outcome.issue
            .map(
              (i) =>
                  i.diagnostics?.valueString ??
                  i.details?.text?.valueString ??
                  i.code.toString(),
            )
            .join('; ');
      }
    } on Object {
      // Not FHIR JSON; the status code alone is reported.
    }
    return '(no OperationOutcome)';
  }

  Uri _url(String path) {
    final base = fhirBase.toString();
    return Uri.parse(base.endsWith('/') ? '$base$path' : '$base/$path');
  }

  static String _parameterName(String type) =>
      type[0].toLowerCase() + type.substring(1);
}
