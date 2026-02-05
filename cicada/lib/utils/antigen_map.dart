import '../cicada.dart';

Map<String, VaxAntigen> antigenMap(VaxPatient patient) {
  final VaxObservations observations = patient.observations;

  final Map<String, VaxAntigen> agMap = <String, VaxAntigen>{};
  for (final AntigenSupportingData data in antigenSupportingData) {
    if (data.series != null &&
        data.series!.isNotEmpty &&
        data.series!.first.targetDisease != null) {
      final List<GroupContraindication> groupContraindications =
          data.contraindications?.vaccineGroup?.contraindication?.toList() ??
              <GroupContraindication>[];
      groupContraindications.retainWhere((GroupContraindication element) =>
          observations.codesAsInt?.contains(element.codeAsInt) ?? false);
      final List<VaccineContraindication> vaccineContraindications =
          data.contraindications?.vaccine?.contraindication?.toList() ??
              <VaccineContraindication>[];
      vaccineContraindications.retainWhere((VaccineContraindication element) =>
          observations.codesAsInt?.contains(element.codeAsInt) ?? false);
      agMap[data.series!.first.targetDisease!] = VaxAntigen.fromSeries(
        series: data.series!,
        groupContraindications: groupContraindications,
        vaccineContraindications: vaccineContraindications,
        patient: patient,
      );
    }
  }
  for (final VaxDose dose in patient.pastDoses) {
    for (final String ag in dose.antigens) {
      if (agMap.keys.contains(ag)) {
        dose.targetDisease = ag;
        agMap[ag]!.newDose(dose);
      }
    }
  }
  return agMap;
}
