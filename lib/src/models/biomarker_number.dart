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
}

@immutable
class BiomarkerNumber {
  static List<BiomarkerValidationRule> getValidationRules({
    required double? maxValue,
    required double? minValue,
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
          rule: () => maxValue == null || minValue == null || minValue <= maxValue,
          errorMessage: 'minValue must be inferior to maxValue => minValue = $minValue, maxValue = $maxValue',
        ),
        ///////////////////////////
        BiomarkerValidationRule(
          rule: () =>
              maxValue == null ||
              minValue == null ||
              maxOptimalValue == null ||
              (maxOptimalValue >= minValue && maxOptimalValue <= maxValue),
          errorMessage:
              'maxOptimalValue (if specified) must be in [minValue, maxValue] => $maxOptimalValue is not in [$minValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxValue == null ||
              minValue == null ||
              minOptimalValue == null ||
              (minOptimalValue >= minValue && minOptimalValue <= maxValue),
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
              maxValue == null ||
              minValue == null ||
              maxVeryBadValue == null ||
              (maxVeryBadValue <= maxValue && maxBadValue != null && maxVeryBadValue >= maxBadValue),
          errorMessage:
              'maxVeryBadValue (if specified) must be in [maxBadValue, maxValue] => $maxVeryBadValue is not in [$maxBadValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxValue == null ||
              minValue == null ||
              maxBadValue == null ||
              (maxBadValue <= maxValue && maxBorderlineValue != null && maxBadValue >= maxBorderlineValue),
          errorMessage:
              'maxBadValue (if specified) must be in [maxBorderlineValue, maxValue] => $maxBadValue is not in [$maxBorderlineValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxValue == null ||
              minValue == null ||
              maxBorderlineValue == null ||
              (maxBorderlineValue <= maxValue && maxOptimalValue != null && maxBorderlineValue >= maxOptimalValue),
          errorMessage:
              'maxBorderlineValue (if specified) must be in [maxOptimalValue, maxValue] => $maxBorderlineValue is not in [$maxOptimalValue, $maxValue]',
        ),
        ///////////////////////////
        BiomarkerValidationRule(
          rule: () =>
              maxValue == null ||
              minValue == null ||
              minVeryBadValue == null ||
              (minVeryBadValue >= minValue && minBadValue != null && minBadValue >= minVeryBadValue),
          errorMessage:
              'minVeryBadValue (if specified) must be in [minValue, minBadValue] => $minVeryBadValue is not in [$minValue, $minBadValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxValue == null ||
              minValue == null ||
              minBadValue == null ||
              (minBadValue >= minValue && minBorderlineValue != null && minBorderlineValue >= minBadValue),
          errorMessage:
              'minBadValue (if specified) must be in [minValue, minBorderlineValue] => $minBadValue is not in [$minValue, $minBorderlineValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxValue == null ||
              minValue == null ||
              minBorderlineValue == null ||
              (minBorderlineValue >= minValue && minOptimalValue != null && minOptimalValue >= minBorderlineValue),
          errorMessage:
              'minBorderlineValue (if specified) must be in [minValue, minOptimalValue] => $minBorderlineValue is not in [$minValue, $minOptimalValue]',
        ),
      ];

  final double value;
  late final double? maxValue;
  late final double? minValue;
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

  /// If [maxValue] is null set it to the highest know max value (if any).
  static double? _computeInferredMaxValue({
    required double? maxOptimalValue,
    required double? maxBorderlineValue,
    required double? maxBadValue,
    required double? maxVeryBadValue,
  }) {
    if (maxVeryBadValue != null) {
      return maxVeryBadValue;
    } else if (maxBadValue != null) {
      return maxBadValue;
    } else if (maxBorderlineValue != null) {
      return maxBorderlineValue;
    } else if (maxOptimalValue != null) {
      return maxOptimalValue;
    }
    return null;
  }

  /// If [minValue] is null set it to the lowest know min value (if any).
  static double? _computeInferredMinValue({
    required double? minOptimalValue,
    required double? minBorderlineValue,
    required double? minBadValue,
    required double? minVeryBadValue,
  }) {
    if (minVeryBadValue != null) {
      return minVeryBadValue;
    } else if (minBadValue != null) {
      return minBadValue;
    } else if (minBorderlineValue != null) {
      return minBorderlineValue;
    } else if (minOptimalValue != null) {
      return minOptimalValue;
    }
    return null;
  }

  static BiomarkerNumberRange _computeRange({
    required double value,
    required double? maxValue,
    required double? minValue,
    required double? maxOptimalValue,
    required double? minOptimalValue,
    required double? maxBorderlineValue,
    required double? minBorderlineValue,
    required double? maxBadValue,
    required double? minBadValue,
    required double? maxVeryBadValue,
    required double? minVeryBadValue,
  }) {
    if (maxValue == null || minValue == null) {
      return BiomarkerNumberRange.unknown;
    }

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

    if (maxOptimalValue != null) {
      if (value > maxOptimalValue) {
        return BiomarkerNumberRange.unknown;
      } else if (minOptimalValue == null) {
        return BiomarkerNumberRange.optimal;
      } else if (value > minOptimalValue) {
        return BiomarkerNumberRange.optimal;
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

    if (minOptimalValue != null) {
      if (value < minOptimalValue) {
        return BiomarkerNumberRange.unknown;
      } else if (maxOptimalValue == null) {
        return BiomarkerNumberRange.optimal;
      } else if (value < maxOptimalValue) {
        return BiomarkerNumberRange.optimal;
      }
    }

    return BiomarkerNumberRange.unknown;
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
    double? maxValue,
    double? minValue,
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
    if (maxValue == null) {
      this.maxValue = _computeInferredMaxValue(
        maxOptimalValue: maxOptimalValue,
        maxBorderlineValue: maxBorderlineValue,
        maxBadValue: maxBadValue,
        maxVeryBadValue: maxVeryBadValue,
      );
    } else {
      this.maxValue = maxValue;
    }

    if (minValue == null) {
      this.minValue = _computeInferredMinValue(
        minOptimalValue: minOptimalValue,
        minBorderlineValue: minBorderlineValue,
        minBadValue: minBadValue,
        minVeryBadValue: minVeryBadValue,
      );
    } else {
      this.minValue = minValue;
    }

    range = _computeRange(
      value: value,
      maxValue: this.maxValue,
      minValue: this.minValue,
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
