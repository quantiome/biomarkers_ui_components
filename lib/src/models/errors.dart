import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/extensions.dart';
import 'biomarker_data.dart';

@immutable
class BiomarkerProcessingException implements Exception {
  final List<String> errors;
  final BiomarkerData biomarker;

  const BiomarkerProcessingException({
    required this.errors,
    required this.biomarker,
  });

  @override
  String toString() => "The biomarker '${biomarker.name}'"
      ' of ${biomarker.time.toNumYearNumMonthNumDayString()}'
      ' (with value = ${biomarker.value})'
      ' has invalid data${errors.isEmpty ? '.' : ':${errors.fold('', (String aggregate, error) => aggregate + '\n - $error')}'}';
}

@immutable
class BiomarkersMismatchException implements Exception {
  final List<dynamic> biomarkers;

  const BiomarkersMismatchException({
    required this.biomarkers,
  });

  @override
  String toString() => 'The biomarkers are of mismatching types:'
      '${biomarkers.fold('', (String aggregate, biomarker) => aggregate + '\n - ${biomarker.name}: ${biomarker.runtimeType}')}';
}

class BiomarkersDuplicatesException implements Exception {
  final List<BiomarkerData> biomarkers;

  const BiomarkersDuplicatesException({
    required this.biomarkers,
  });

  @override
  String toString() => 'There is more than one biomarker with the exact same data at these dates:'
      '${biomarkers.fold('', (String aggregate, biomarker) => aggregate + '\n - ${biomarker.time}')}';
}

class BiomarkersDifferentNamesException implements Exception {
  final List<BiomarkerData> biomarkers;

  const BiomarkersDifferentNamesException({
    required this.biomarkers,
  });

  @override
  String toString() =>
      'Some of these biomarkers have different names, are you sure they should be displayed together as a group?:'
      '${biomarkers.fold('', (String aggregate, biomarker) => aggregate + '\n - ${biomarker.name}: ${biomarker.time}')}';
}
