import 'dart:convert';
import 'package:cicada/forecast/forecast.dart';
import 'package:cicada/utils/fhir_xml_to_json.dart';

void main() {
  const xml = '''<?xml version="1.0" encoding="UTF-8"?>
<Parameters xmlns="http://hl7.org/fhir">
  <parameter>
    <name value="assessmentDate"/>
    <valueDate value="2026-02-11"/>
  </parameter>
  <parameter>
    <name value="patient"/>
    <resource>
      <Patient>
        <id value="2013-0001"/>
        <gender value="female"/>
        <birthDate value="2025-11-10"/>
        <name>
          <family value="Newborn"/>
          <given value="Testing"/>
        </name>
      </Patient>
    </resource>
  </parameter>
  <parameter>
    <name value="immunization"/>
    <resource>
      <Immunization>
        <id value="imm-1"/>
        <status value="completed"/>
        <vaccineCode>
          <coding>
            <system value="http://hl7.org/fhir/sid/cvx"/>
            <code value="08"/>
          </coding>
        </vaccineCode>
        <patient>
          <reference value="Patient/2013-0001"/>
        </patient>
        <occurrenceDateTime value="2026-01-10"/>
      </Immunization>
    </resource>
  </parameter>
</Parameters>''';

  final json = fhirXmlToJson(xml);
  final output = forecastFromMap(json);
  final encoder = JsonEncoder.withIndent('  ');
  print(encoder.convert(output.toJson()));
}
