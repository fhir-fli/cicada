<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2">
  <sch:ns prefix="f" uri="http://hl7.org/fhir"/>
  <sch:ns prefix="h" uri="http://www.w3.org/1999/xhtml"/>
  <!-- 
    This file contains just the constraints for the profile Immunization
    It includes the base constraints for the resource as well.
    Because of the way that schematrons and containment work, 
    you may need to use this schematron fragment to build a, 
    single schematron that validates contained resources (if you have any) 
  -->
  <sch:pattern>
    <sch:title>f:Immunization</sch:title>
    <sch:rule context="f:Immunization">
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/assessment-date']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/assessment-date': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/inadvertent-administration-status']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/inadvertent-administration-status': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/valid-age-status']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/valid-age-status': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/valid-age-reason']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/valid-age-reason': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-interval-status']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-interval-status': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-interval-reason']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-interval-reason': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-status']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-status': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-reason']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-interval-reason': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vaccination-conflict']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/vaccination-conflict': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-status']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-status': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-reason']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/preferred-vaccine-reason': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-status']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-status': maximum cardinality of 'extension' is 1</sch:assert>
      <sch:assert test="count(f:extension[@url = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-reason']) &lt;= 1">extension with URL = 'http://fhirfli.dev/fhir/ig/cicada/StructureDefinition/allowed-vaccine-reason': maximum cardinality of 'extension' is 1</sch:assert>
    </sch:rule>
  </sch:pattern>
</sch:schema>
