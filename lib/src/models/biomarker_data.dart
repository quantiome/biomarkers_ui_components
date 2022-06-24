import 'package:flutter/foundation.dart';

import 'biomarker_number.dart';
import 'biomarker_string.dart';
import 'errors.dart';

/// This can takes a dynamic value and be converted to a usable type with [convertToKnownType] (if there are no issues with hte data.
/// [BiomarkerCard] can take a list of [BiomarkerData] and will do data conversion to display the right card.
@immutable
class BiomarkerData {
  /// If the value is a string starting with a known number prefix like '<2' (e.g. for undetectable amount of biomarker)
  /// then we produce a [BiomarkerNumber] using this number and prefix.
  static final List<String> numberPrefixes = ['<', '>'];

  /// The value could be one of:
  ///  - Pure number (e.g 42) => We should convert to a [BiomarkerNumber].
  ///  - String number with prefix (e.g '<2') => We should convert to a [BiomarkerNumber].
  ///  - Pure String (e.g. 'Positive') => We should convert to a [BiomarkerString].
  ///  - String multi number (e.g. '140 | 152'). Same as pure String => We should convert to a [BiomarkerString].
  final dynamic value;
  final double? maxValue;
  final double? minValue;
  final double? maxOptimalValue;
  final double? minOptimalValue;
  final double? maxBorderlineValue;
  final double? minBorderlineValue;
  final double? maxBadValue;
  final double? minBadValue;
  final double? maxVeryBadValue;
  final double? minVeryBadValue;
  final DateTime time;
  final String name;
  final String? unit;

  /// {@macro groqhealth.widgets.range_indicator.values}
  const BiomarkerData({
    required this.value,
    this.maxValue,
    this.minValue,
    this.maxOptimalValue,
    this.minOptimalValue,
    this.maxBorderlineValue,
    this.minBorderlineValue,
    this.maxBadValue,
    this.minBadValue,
    this.maxVeryBadValue,
    this.minVeryBadValue,
    required this.time,
    required this.name,
    this.unit,
  });

  dynamic convertToKnownType() {
    late final double? numberValue;
    String? numberPrefix;

    if (value is num) {
      numberValue = (value as num).toDouble();
    } else if (value is String) {
      final String string = (value as String).trim();
      if (string.isEmpty) {
        throw BiomarkerProcessingException(
          errors: const ['The value type is a String but it is empty.'],
          biomarker: this,
        );
      }

      numberPrefix = numberPrefixes.firstWhere(
        (prefix) => string.startsWith(prefix),
        orElse: () => '',
      );
      if (numberPrefix.isNotEmpty) {
        /// The string is a 'number with prefix'.
        final String numberString = string.substring(numberPrefix.length);
        numberValue = double.tryParse(numberString);
      } else {
        /// The string is a 'pure String'.
        return BiomarkerString(
          value: value as String,
          time: time,
          name: name,
          unit: unit,
          maxOptimalValue: maxOptimalValue,
          minOptimalValue: minOptimalValue,
        );
      }
    } else {
      throw BiomarkerProcessingException(
        errors: ['The value is of unsupported type = $runtimeType'],
        biomarker: this,
      );
    }

    /// The value is a number.
    final bool isNumberValid = numberValue != null;
    final bool isMaxValueValid = maxValue != null;
    final bool isMinValueValid = minValue != null;

    final List<String> errors = [];
    if (!isMaxValueValid || !isMinValueValid) {
      if (!isNumberValid) errors.add('Invalid number = $numberValue');
      if (!isMaxValueValid) errors.add('Invalid maxValue = $maxValue');
      if (!isMinValueValid) errors.add('Invalid minValue = $minValue');
    } else {
      final List<String> validationErrors = BiomarkerNumber.getValidationRules(
        maxValue: maxValue!,
        minValue: minValue!,
        maxOptimalValue: maxOptimalValue,
        minOptimalValue: minOptimalValue,
        maxBorderlineValue: maxBorderlineValue,
        minBorderlineValue: minBorderlineValue,
        maxBadValue: maxBadValue,
        minBadValue: minBadValue,
        maxVeryBadValue: maxVeryBadValue,
        minVeryBadValue: minVeryBadValue,
      ).where((rule) => !rule.isRespected).map((rule) => rule.errorMessage).toList();
      if (validationErrors.isNotEmpty) {
        if (!isNumberValid) errors.add('Invalid number = $numberValue');
        for (final String validationError in validationErrors) {
          errors.add(validationError);
        }
      } else if (!isNumberValid) {
        errors.add('Invalid number = $numberValue');
      }
    }

    if (errors.isNotEmpty) {
      throw BiomarkerProcessingException(
        errors: errors,
        biomarker: this,
      );
    }

    return BiomarkerNumber(
      value: numberValue!,
      maxValue: maxValue!,
      minValue: minValue!,
      maxOptimalValue: maxOptimalValue,
      minOptimalValue: minOptimalValue,
      maxBorderlineValue: maxBorderlineValue,
      minBorderlineValue: minBorderlineValue,
      maxBadValue: maxBadValue,
      minBadValue: minBadValue,
      maxVeryBadValue: maxVeryBadValue,
      minVeryBadValue: minVeryBadValue,
      time: time,
      name: name,
      unit: unit,
      prefix: numberPrefix,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BiomarkerData &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          maxValue == other.maxValue &&
          minValue == other.minValue &&
          maxOptimalValue == other.maxOptimalValue &&
          minOptimalValue == other.minOptimalValue &&
          maxBorderlineValue == other.maxBorderlineValue &&
          minBorderlineValue == other.minBorderlineValue &&
          maxBadValue == other.maxBadValue &&
          minBadValue == other.minBadValue &&
          maxVeryBadValue == other.maxVeryBadValue &&
          minVeryBadValue == other.minVeryBadValue &&
          time == other.time &&
          name == other.name &&
          unit == other.unit;

  @override
  int get hashCode =>
      value.hashCode ^
      maxValue.hashCode ^
      minValue.hashCode ^
      maxOptimalValue.hashCode ^
      minOptimalValue.hashCode ^
      maxBorderlineValue.hashCode ^
      minBorderlineValue.hashCode ^
      maxBadValue.hashCode ^
      minBadValue.hashCode ^
      maxVeryBadValue.hashCode ^
      minVeryBadValue.hashCode ^
      time.hashCode ^
      name.hashCode ^
      unit.hashCode;
}
