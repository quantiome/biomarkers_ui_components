import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../utils/colors.dart';
import 'biomarker_validation_rule.dart';

enum BiomarkerNumberRange {
  veryHigh,
  high,
  borderlineHigh,
  optimal,
  borderLineLow,
  low,
  veryLow,
  unknown,
}

extension BiomarkerNumberRangeExtension on BiomarkerNumberRange {
  Color get color {
    switch (this) {
      case BiomarkerNumberRange.veryHigh:
        return AppColors.biomarkerVeryBadHigh;
      case BiomarkerNumberRange.high:
        return AppColors.biomarkerBadHigh;
      case BiomarkerNumberRange.borderlineHigh:
        return AppColors.biomarkerBorderlineHigh;
      case BiomarkerNumberRange.optimal:
        return AppColors.biomarkerOptimal;
      case BiomarkerNumberRange.borderLineLow:
        return AppColors.biomarkerBorderlineLow;
      case BiomarkerNumberRange.low:
        return AppColors.biomarkerBadLow;
      case BiomarkerNumberRange.veryLow:
        return AppColors.biomarkerVeryBadLow;
      case BiomarkerNumberRange.unknown:
        return AppColors.biomarkerDefault;
    }
  }

  String get humanReadableName {
    switch (this) {
      case BiomarkerNumberRange.veryHigh:
        return 'Very high';
      case BiomarkerNumberRange.high:
        return 'High';
      case BiomarkerNumberRange.borderlineHigh:
        return 'Rather high';
      case BiomarkerNumberRange.optimal:
        return 'Optimal';
      case BiomarkerNumberRange.borderLineLow:
        return 'Rather Low';
      case BiomarkerNumberRange.low:
        return 'Low';
      case BiomarkerNumberRange.veryLow:
        return 'Very Low';
      case BiomarkerNumberRange.unknown:
        return '';
    }
  }
}

@immutable
class BiomarkerNumber {
  static List<BiomarkerValidationRule> getValidationRules({
    required double maxValue,
    required double minValue,
    required double? maxOptimalValue,
    required double? minOptimalValue,
    required double? maxBorderlineValue,
    required double? minBorderlineValue,
    required double? maxBadValue,
    required double? minBadValue,
    required double? maxVeryBadValue,
    required double? minVeryBadValue,
  }) =>
      [
        BiomarkerValidationRule(
          rule: () => minValue <= maxValue,
          errorMessage: 'minValue must be inferior to maxValue => minValue = $minValue, maxValue = $maxValue',
        ),
        ///////////////////////////
        BiomarkerValidationRule(
          rule: () => maxOptimalValue == null || maxOptimalValue >= minValue && maxOptimalValue <= maxValue,
          errorMessage:
              'maxOptimalValue (if specified) must be in [minValue, maxValue] => $maxOptimalValue is not in [$minValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () => minOptimalValue == null || minOptimalValue >= minValue && minOptimalValue <= maxValue,
          errorMessage:
              'minOptimalValue (if specified) must be in [minValue, maxValue] => $minOptimalValue is not in [$minValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () => maxOptimalValue == null || minOptimalValue == null || maxOptimalValue >= minOptimalValue,
          errorMessage: 'If maxOptimalValue and minOptimalValue are both not null then maxOptimalValue'
              ' must be >= to minOptimalValue => maxOptimalValue = $maxOptimalValue, minOptimalValue = $minOptimalValue.',
        ),
        ///////////////////////////
        BiomarkerValidationRule(
          rule: () =>
              maxVeryBadValue == null ||
              (maxVeryBadValue <= maxValue && maxBadValue != null && maxVeryBadValue >= maxBadValue),
          errorMessage:
              'maxVeryBadValue (if specified) must be in [maxBadValue, maxValue] => $maxVeryBadValue is not in [$maxBadValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxBadValue == null ||
              (maxBadValue <= maxValue && maxBorderlineValue != null && maxBadValue >= maxBorderlineValue),
          errorMessage:
              'maxBadValue (if specified) must be in [maxBorderlineValue, maxValue] => $maxBadValue is not in [$maxBorderlineValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxBorderlineValue == null ||
              (maxBorderlineValue <= maxValue && maxOptimalValue != null && maxBorderlineValue >= maxOptimalValue),
          errorMessage:
              'maxBorderlineValue (if specified) must be in [maxOptimalValue, maxValue] => $maxBorderlineValue is not in [$maxOptimalValue, $maxValue]',
        ),
        ///////////////////////////
        BiomarkerValidationRule(
          rule: () =>
              minVeryBadValue == null ||
              (minVeryBadValue >= minValue && minBadValue != null && minBadValue >= minVeryBadValue),
          errorMessage:
              'minVeryBadValue (if specified) must be in [minValue, minBadValue] => $minVeryBadValue is not in [$minValue, $minBadValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              minBadValue == null ||
              (minBadValue >= minValue && minBorderlineValue != null && minBorderlineValue >= minBadValue),
          errorMessage:
              'minBadValue (if specified) must be in [minValue, minBorderlineValue] => $minBadValue is not in [$minValue, $minBorderlineValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              minBorderlineValue == null ||
              (minBorderlineValue >= minValue && minOptimalValue != null && minOptimalValue >= minBorderlineValue),
          errorMessage:
              'minBorderlineValue (if specified) must be in [minValue, minOptimalValue] => $minBorderlineValue is not in [$minValue, $minOptimalValue]',
        ),
      ];

  final double value;
  final double maxValue;
  final double minValue;
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
  final String? prefix;
  late final BiomarkerNumberRange range;

  static BiomarkerNumberRange _computeRange({
    required double value,
    required double maxValue,
    required double minValue,
    required double? maxOptimalValue,
    required double? minOptimalValue,
    required double? maxBorderlineValue,
    required double? minBorderlineValue,
    required double? maxBadValue,
    required double? minBadValue,
    required double? maxVeryBadValue,
    required double? minVeryBadValue,
  }) {
    if (value > maxValue || value < minValue) {
      return BiomarkerNumberRange.unknown;
    }

    if (maxVeryBadValue != null) {
      if (value > maxVeryBadValue) {
        return BiomarkerNumberRange.unknown;
      } else if (maxBadValue == null) {
        /// This should not happen [maxBadValue] is required if [maxVeryBadValue] is not null.
        return BiomarkerNumberRange.unknown;
      } else if (value > maxBadValue) {
        return BiomarkerNumberRange.veryHigh;
      }
    }

    if (maxBadValue != null) {
      if (value > maxBadValue) {
        return BiomarkerNumberRange.unknown;
      } else if (maxBorderlineValue == null) {
        /// This should not happen [maxBorderlineValue] is required if [maxBadValue] is not null.
        return BiomarkerNumberRange.unknown;
      } else if (value > maxBorderlineValue) {
        return BiomarkerNumberRange.high;
      }
    }

    if (maxBorderlineValue != null) {
      if (value > maxBorderlineValue) {
        return BiomarkerNumberRange.unknown;
      } else if (maxOptimalValue == null) {
        /// This should not happen [maxOptimalValue] is required if [maxBorderlineValue] is not null.
        return BiomarkerNumberRange.unknown;
      } else if (value > maxOptimalValue) {
        return BiomarkerNumberRange.borderlineHigh;
      }
    }

    if (minVeryBadValue != null) {
      if (value < minVeryBadValue) {
        return BiomarkerNumberRange.unknown;
      } else if (minBadValue == null) {
        /// This should not happen [minBadValue] is required if [minVeryBadValue] is not null.
        return BiomarkerNumberRange.unknown;
      } else if (value < minBadValue) {
        return BiomarkerNumberRange.veryLow;
      }
    }

    if (minBadValue != null) {
      if (value < minBadValue) {
        return BiomarkerNumberRange.unknown;
      } else if (minBorderlineValue == null) {
        /// This should not happen [minBorderlineValue] is required if [minBadValue] is not null.
        return BiomarkerNumberRange.unknown;
      } else if (value < minBorderlineValue) {
        return BiomarkerNumberRange.low;
      }
    }

    if (minBorderlineValue != null) {
      if (value < minBorderlineValue) {
        return BiomarkerNumberRange.unknown;
      } else if (minOptimalValue == null) {
        /// This should not happen [minOptimalValue] is required if [minBorderlineValue] is not null.
        return BiomarkerNumberRange.unknown;
      } else if (value < minOptimalValue) {
        return BiomarkerNumberRange.borderLineLow;
      }
    }

    return BiomarkerNumberRange.optimal;
  }

  /// The following rules must be respected:
  /// value ∈ [minValue, maxValue]
  /// If a BorderlineValue is not null then its corresponding OptimalValue must also be not null.
  /// Same for LowValue/HighValue and VeryLowValue/VeryHighValue, each higher range require all the previous ranges to be there.
  /// if not null a BorderlineValue should always be above (for max) or below (for min) its corresponding OptimalValue.
  /// Same for LowValue/HighValue and VeryLowValue/VeryHighValue.
  /// a min should always be <= to its corresponding max.
  /// By default the whole bar is painted in [AppColors.biomarkerDefault].
  /// More colors are added based on the optional min/max values.
  BiomarkerNumber({
    required this.value,
    required this.maxValue,
    required this.minValue,
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
    this.prefix,
  }) {
    range = _computeRange(
      value: value,
      maxValue: maxValue,
      minValue: minValue,
      maxOptimalValue: maxOptimalValue,
      minOptimalValue: minOptimalValue,
      maxBorderlineValue: maxBorderlineValue,
      minBorderlineValue: minBorderlineValue,
      maxBadValue: maxBadValue,
      minBadValue: minBadValue,
      maxVeryBadValue: maxVeryBadValue,
      minVeryBadValue: minVeryBadValue,
    );
  }
}
