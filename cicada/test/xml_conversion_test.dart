import 'dart:convert';
import 'dart:io';

import 'package:fhir_r4/fhir_r4.dart';
import 'package:cicada/cicada.dart';
import 'package:test/test.dart';

/// Load the first N test cases from the NDJSON file.
List<Parameters> _loadFirstN(String path, int n) {
  final lines = File(path).readAsLinesSync();
  final result = <Parameters>[];

  for (final line in lines) {
    if (result.length >= n) break;
    final trimmed = line.trim();
    if (trimmed.isEmpty) continue;

    final decoded = jsonDecode(trimmed) as Map<String, dynamic>;
    final paramList = decoded['parameter'] as List<dynamic>?;
    if (paramList == null) continue;

    for (final p in paramList) {
      final param = p as Map<String, dynamic>;
      if (param.containsKey('resource')) {
        final resource = param['resource'] as Map<String, dynamic>;
        if (resource['resourceType'] == 'Immunization' &&
            !resource.containsKey('status')) {
          resource['status'] = 'completed';
        }
      }
    }

    result.add(Parameters.fromJson(decoded));
  }

  return result;
}

void main() {
  late Parameters noDoseCase;
  late Parameters withDosesCase;

  setUpAll(() {
    final cases = _loadFirstN('test/healthyTestCases.ndjson', 2);
    noDoseCase = cases[0];
    withDosesCase = cases[1];
  });

  group('JSON -> XML -> JSON roundtrip', () {
    test('forecast output survives roundtrip (no doses)', () {
      final result = evaluateForForecast(noDoseCase);
      final response = buildImmdsResponse(result);
      final originalJson = response.toJson();

      // JSON -> XML
      final xml = fhirJsonToXml(originalJson);
      expect(xml, contains('<Parameters'));
      expect(xml, contains('xmlns="http://hl7.org/fhir"'));

      // XML -> JSON
      final roundtrippedJson = fhirXmlToJson(xml);

      // Verify key fields survive
      expect(roundtrippedJson['resourceType'], 'Parameters');
      final params = roundtrippedJson['parameter'] as List;
      expect(params, isNotEmpty);

      // Find the recommendation parameter
      final recParam = params.firstWhere(
          (p) => (p as Map)['name'] == 'recommendation',
          orElse: () => null);
      expect(recParam, isNotNull, reason: 'recommendation parameter missing');
      final recResource =
          (recParam as Map)['resource'] as Map<String, dynamic>;
      expect(recResource['resourceType'], 'ImmunizationRecommendation');

      // Verify recommendation array exists
      expect(recResource['recommendation'], isA<List>());
      expect((recResource['recommendation'] as List), isNotEmpty);
    });

    test('forecast output survives roundtrip (with doses)', () {
      final result = evaluateForForecast(withDosesCase);
      final response = buildImmdsResponse(result);
      final originalJson = response.toJson();

      final xml = fhirJsonToXml(originalJson);
      final roundtrippedJson = fhirXmlToJson(xml);

      expect(roundtrippedJson['resourceType'], 'Parameters');
      final params = roundtrippedJson['parameter'] as List;

      // Count evaluations and recommendations
      final evalParams =
          params.where((p) => (p as Map)['name'] == 'evaluation').toList();
      final recParams = params
          .where((p) => (p as Map)['name'] == 'recommendation')
          .toList();

      // With-doses case should have evaluations
      expect(evalParams, isNotEmpty,
          reason: 'expected evaluation parameters for case with doses');
      expect(recParams.length, 1);

      // Verify evaluation structure survives
      for (final ep in evalParams) {
        final resource =
            (ep as Map)['resource'] as Map<String, dynamic>;
        expect(resource['resourceType'], 'ImmunizationEvaluation');
        expect(resource['doseStatus'], isNotNull,
            reason: 'doseStatus lost in roundtrip');
      }
    });

    test('date values preserved through roundtrip', () {
      final result = evaluateForForecast(noDoseCase);
      final response = buildImmdsResponse(result);
      final originalJson = response.toJson();

      final xml = fhirJsonToXml(originalJson);
      final roundtrippedJson = fhirXmlToJson(xml);

      // Extract recommendation dates from original
      final origRec = (originalJson['parameter'] as List)
          .firstWhere((p) => (p as Map)['name'] == 'recommendation');
      final origRecResource =
          (origRec as Map)['resource'] as Map<String, dynamic>;
      final origDate = origRecResource['date'];

      // Extract from roundtripped
      final rtRec = (roundtrippedJson['parameter'] as List)
          .firstWhere((p) => (p as Map)['name'] == 'recommendation');
      final rtRecResource =
          (rtRec as Map)['resource'] as Map<String, dynamic>;
      final rtDate = rtRecResource['date'];

      expect(rtDate, origDate, reason: 'recommendation date changed');
    });
  });

  group('XML -> JSON for FITS-style input', () {
    test('simple Parameters with Patient converts correctly', () {
      // Build a minimal FHIR Parameters XML like FITS would send
      const xmlInput = '''<?xml version="1.0" encoding="UTF-8"?>
<Parameters xmlns="http://hl7.org/fhir">
  <parameter>
    <name value="Patient"/>
    <resource>
      <Patient xmlns="http://hl7.org/fhir">
        <id value="test-patient-1"/>
        <birthDate value="2025-01-01"/>
        <gender value="female"/>
      </Patient>
    </resource>
  </parameter>
</Parameters>''';

      final json = fhirXmlToJson(xmlInput);

      expect(json['resourceType'], 'Parameters');
      final params = json['parameter'] as List;
      expect(params, isNotEmpty);

      final patientParam = params.first as Map<String, dynamic>;
      expect(patientParam['name'], 'Patient');
      final resource = patientParam['resource'] as Map<String, dynamic>;
      expect(resource['resourceType'], 'Patient');
      expect(resource['id'], 'test-patient-1');
      expect(resource['birthDate'], '2025-01-01');
      expect(resource['gender'], 'female');
    });

    test('Parameters with Patient and Immunization converts correctly', () {
      const xmlInput = '''<?xml version="1.0" encoding="UTF-8"?>
<Parameters xmlns="http://hl7.org/fhir">
  <parameter>
    <name value="Patient"/>
    <resource>
      <Patient xmlns="http://hl7.org/fhir">
        <id value="test-patient-2"/>
        <birthDate value="2024-06-15"/>
        <gender value="male"/>
      </Patient>
    </resource>
  </parameter>
  <parameter>
    <name value="Immunization"/>
    <resource>
      <Immunization xmlns="http://hl7.org/fhir">
        <id value="imm-1"/>
        <status value="completed"/>
        <vaccineCode>
          <coding>
            <system value="http://hl7.org/fhir/sid/cvx"/>
            <code value="110"/>
          </coding>
        </vaccineCode>
        <occurrenceDateTime value="2024-08-15"/>
      </Immunization>
    </resource>
  </parameter>
</Parameters>''';

      final json = fhirXmlToJson(xmlInput);

      expect(json['resourceType'], 'Parameters');
      final params = json['parameter'] as List;
      expect(params.length, 2);

      // Check Immunization
      final immParam = params[1] as Map<String, dynamic>;
      final immResource = immParam['resource'] as Map<String, dynamic>;
      expect(immResource['resourceType'], 'Immunization');
      expect(immResource['id'], 'imm-1');
      expect(immResource['status'], 'completed');
      expect(immResource['occurrenceDateTime'], '2024-08-15');

      // Check vaccineCode coding
      final vaccineCode = immResource['vaccineCode'] as Map<String, dynamic>;
      final coding = (vaccineCode['coding'] as List).first as Map;
      expect(coding['system'], 'http://hl7.org/fhir/sid/cvx');
      expect(coding['code'], '110');
    });
  });

  group('End-to-end server pipeline', () {
    test('XML input -> forecast -> XML output roundtrip', () {
      // Take a real test case, convert to XML, then go through the full
      // pipeline: XML -> JSON -> forecast -> JSON -> XML -> verify
      final inputJson = noDoseCase.toJson();
      final inputXml = fhirJsonToXml(inputJson);

      // XML -> JSON (simulates server XML input parsing)
      final parsedJson = fhirXmlToJson(inputXml);
      expect(parsedJson['resourceType'], 'Parameters');

      // JSON -> forecast (simulates forecastFromMap)
      final forecastOutput = forecastFromMap(parsedJson);
      expect(forecastOutput.parameter, isNotNull);

      // Forecast output -> XML (simulates server XML output)
      final outputJson = forecastOutput.toJson();
      final outputXml = fhirJsonToXml(outputJson);
      expect(outputXml, contains('<Parameters'));
      expect(outputXml, contains('<ImmunizationRecommendation'));

      // Verify the XML can be parsed back
      final finalJson = fhirXmlToJson(outputXml);
      expect(finalJson['resourceType'], 'Parameters');
    });

    test('XML input with immunizations -> forecast -> XML output', () {
      final inputJson = withDosesCase.toJson();
      final inputXml = fhirJsonToXml(inputJson);

      final parsedJson = fhirXmlToJson(inputXml);
      final forecastOutput = forecastFromMap(parsedJson);

      final outputJson = forecastOutput.toJson();
      final outputXml = fhirJsonToXml(outputJson);

      expect(outputXml, contains('<ImmunizationEvaluation'));
      expect(outputXml, contains('<ImmunizationRecommendation'));

      // Verify the final XML is parseable
      final finalJson = fhirXmlToJson(outputXml);
      final params = finalJson['parameter'] as List;
      final evalCount =
          params.where((p) => (p as Map)['name'] == 'evaluation').length;
      expect(evalCount, greaterThan(0),
          reason: 'evaluations should survive full pipeline');
    });
  });

  group('fhirJsonToXml edge cases', () {
    test('throws on missing resourceType', () {
      expect(
        () => fhirJsonToXml({'id': 'test'}),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('handles empty Parameters', () {
      final xml = fhirJsonToXml({
        'resourceType': 'Parameters',
      });
      expect(xml, contains('<Parameters'));
      expect(xml, contains('xmlns="http://hl7.org/fhir"'));
    });
  });

  group('fhirXmlToJson edge cases', () {
    test('handles minimal Parameters', () {
      const xml = '''<?xml version="1.0" encoding="UTF-8"?>
<Parameters xmlns="http://hl7.org/fhir"/>''';

      final json = fhirXmlToJson(xml);
      expect(json['resourceType'], 'Parameters');
    });
  });
}
