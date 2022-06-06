import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../utils/colors.dart';
import 'biomarker_validation_rule.dart';

@immutable
class BiomarkerNumber {
  static List<BiomarkerValidationRule> getValidationRules({
    required double maxValue,
    required double minValue,
    required double? maxOptimalValue,
    required double? minOptimalValue,
    required double? maxBorderlineValue,
    required double? minBorderlineValue,
  }) =>
      [
        BiomarkerValidationRule(
          rule: () => minValue <= maxValue,
          errorMessage: 'minValue must be inferior to maxValue => minValue = $minValue, maxValue = $maxValue',
        ),
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
        BiomarkerValidationRule(
          rule: () => maxBorderlineValue == null || maxBorderlineValue >= minValue && maxBorderlineValue <= maxValue,
          errorMessage:
              'maxBorderlineValue (if specified) must be in [minValue, maxValue] => $maxBorderlineValue is not in [$minValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () => minBorderlineValue == null || minBorderlineValue >= minValue && minBorderlineValue <= maxValue,
          errorMessage:
              'minBorderlineValue (if specified) must be in [minValue, maxValue] => $minBorderlineValue is not in [$minValue, $maxValue]',
        ),
        BiomarkerValidationRule(
          rule: () =>
              maxBorderlineValue == null || minBorderlineValue == null || maxBorderlineValue >= minBorderlineValue,
          errorMessage: 'If maxBorderlineValue and minBorderlineValue are both not null then maxBorderlineValue'
              ' must be >= to minBorderlineValue => maxBorderlineValue = $maxBorderlineValue, minBorderlineValue = $minBorderlineValue.',
        ),
        BiomarkerValidationRule(
          rule: () => maxBorderlineValue == null || maxOptimalValue != null,
          errorMessage: 'If maxBorderlineValue is non null then maxOptimalValue must also be non null.',
        ),
        BiomarkerValidationRule(
          rule: () => maxOptimalValue == null || maxBorderlineValue == null || maxBorderlineValue >= maxOptimalValue,
          errorMessage: 'If maxOptimalValue and maxBorderlineValue are both not null then maxBorderlineValue'
              ' must be >= to maxOptimalValue => maxBorderlineValue = $maxBorderlineValue, maxOptimalValue = $maxOptimalValue.',
        ),
        BiomarkerValidationRule(
          rule: () => maxOptimalValue == null || minBorderlineValue == null || maxOptimalValue >= minBorderlineValue,
          errorMessage: 'If maxOptimalValue and minBorderlineValue are both not null then maxOptimalValue'
              ' must be >= to minBorderlineValue => maxOptimalValue = $maxOptimalValue, minBorderlineValue = $minBorderlineValue.',
        ),
        BiomarkerValidationRule(
          rule: () => minBorderlineValue == null || minOptimalValue != null,
          errorMessage: 'If minBorderlineValue is non null then minOptimalValue must also be non null.',
        ),
        BiomarkerValidationRule(
          rule: () => minOptimalValue == null || maxBorderlineValue == null || maxBorderlineValue >= minOptimalValue,
          errorMessage: 'If minOptimalValue and maxBorderlineValue are both not null then maxBorderlineValue'
              ' must be >= to minOptimalValue => maxBorderlineValue = $maxBorderlineValue, minOptimalValue = $minOptimalValue.',
        ),
        BiomarkerValidationRule(
          rule: () => minOptimalValue == null || minBorderlineValue == null || minOptimalValue >= minBorderlineValue,
          errorMessage: 'If minOptimalValue and minBorderlineValue are both not null then minOptimalValue'
              ' must be >= to minBorderlineValue => minOptimalValue = $minOptimalValue, minBorderlineValue = $minBorderlineValue.',
        ),
        BiomarkerValidationRule(
          rule: () => minOptimalValue == null || minBorderlineValue == null || minOptimalValue >= minBorderlineValue,
          errorMessage: 'If minOptimalValue and minBorderlineValue are both not null then minOptimalValue'
              ' must be >= to minBorderlineValue => minOptimalValue = $minOptimalValue, minBorderlineValue = $minBorderlineValue.',
        ),
      ];

  static const Color optimalColor = AppColors.purple500;
  static const Color borderlineColor = AppColors.gold;
  static const Color needsAttentionColor = AppColors.grey400;

  final double value;
  final double maxValue;
  final double minValue;
  final double? maxOptimalValue;
  final double? minOptimalValue;
  final double? maxBorderlineValue;
  final double? minBorderlineValue;
  final DateTime time;
  final String name;
  final String? unit;
  final String? prefix;
  final Color color;

  static Color _computeColor({
    required double value,
    required double? maxOptimalValue,
    required double? minOptimalValue,
    required double? maxBorderlineValue,
    required double? minBorderlineValue,
  }) {
    if (maxOptimalValue != null && value > maxOptimalValue) {
      if (maxBorderlineValue != null) {
        if (value > maxBorderlineValue) {
          return needsAttentionColor;
        } else {
          return borderlineColor;
        }
      } else {
        return needsAttentionColor;
      }
    }
    if (minOptimalValue != null && value < minOptimalValue) {
      if (minBorderlineValue != null) {
        if (value < minBorderlineValue) {
          return needsAttentionColor;
        } else {
          return borderlineColor;
        }
      } else {
        return needsAttentionColor;
      }
    }

    return optimalColor;
  }

  /// The following rules must be respected:
  /// value ∈ [minValue, maxValue]
  /// if a BorderlineValue is not null then its corresponding OptimalValue must also be not null.
  /// if a not null a BorderlineValue should always be above (for max) or below (for min) its corresponding OptimalValue.
  /// a min should always be <= to its corresponding max.
  /// By default the whole bar is painted in [barDefaultColor].
  /// If [minBorderlineValue] is not null then the section from there up to [minOptimalValue] is colored in [barBorderlineColor].
  /// If [minOptimalValue] is not null then the section from there up to the first of either [maxOptimalValue] or [maxValue] is colored in [barOptimalColor].
  /// If [maxBorderlineValue] is not null then the section from there down to [maxOptimalValue] is colored in [barOptimalColor].
  ///
  BiomarkerNumber({
    required this.value,
    required this.maxValue,
    required this.minValue,
    this.maxOptimalValue,
    this.minOptimalValue,
    this.maxBorderlineValue,
    this.minBorderlineValue,
    required this.time,
    required this.name,
    this.unit,
    this.prefix,
  }) : color = _computeColor(
          value: value,
          maxOptimalValue: maxOptimalValue,
          minOptimalValue: minOptimalValue,
          maxBorderlineValue: maxBorderlineValue,
          minBorderlineValue: minBorderlineValue,
        );
}
