import 'package:flutter/foundation.dart';

@immutable
class BiomarkerString {
  final String value;
  final DateTime time;
  final String name;
  final String? unit;

  const BiomarkerString({
    required this.value,
    required this.time,
    required this.name,
    this.unit,
  });
}
