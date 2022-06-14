import 'package:flutter/foundation.dart';

@immutable
class BiomarkerString {
  final String value;
  final DateTime time;
  final String name;
  final String? unit;
  final double? maxOptimalValue;
  final double? minOptimalValue;

  bool get hasOptimalRange => maxOptimalValue != null || minOptimalValue != null;

  const BiomarkerString({
    required this.value,
    required this.time,
    required this.name,
    this.unit,
    this.maxOptimalValue,
    this.minOptimalValue,
  });
}
