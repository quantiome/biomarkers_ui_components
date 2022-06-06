import 'package:flutter/foundation.dart';

typedef ValidationRule = bool Function();

@immutable
class BiomarkerValidationRule {
  final ValidationRule rule;
  final String errorMessage;

  bool get isRespected => rule();

  const BiomarkerValidationRule({
    required this.rule,
    required this.errorMessage,
  });
}
