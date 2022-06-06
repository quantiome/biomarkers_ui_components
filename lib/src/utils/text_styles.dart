import 'package:flutter/material.dart';

import 'colors.dart';

/// Those need to match what's in the pubspec.yaml
abstract class AppFonts {
  AppFonts._();

  static const String avenirMedium = 'avenirMedium';
  static const String avenirBook = 'avenirBook';
  static const String avenirRoman = 'avenirRoman';
  static const String loraMedium = 'LoraMedium';
}

abstract class AppTextStyles {
  AppTextStyles._();

  static const TextStyle biomarkerName = TextStyle(
    color: AppColors.grey900,
    fontSize: 16,
    fontFamily: AppFonts.avenirMedium,
  );

  static const TextStyle biomarkerDate = TextStyle(
    color: AppColors.grey600,
    fontSize: 14,
    fontFamily: AppFonts.avenirBook,
  );

  static const TextStyle biomarkerCardRangeIndicatorValue = TextStyle(
    color: AppColors.grey900,
    fontSize: 48,
    fontFamily: AppFonts.avenirBook,
  );

  static const TextStyle biomarkerCardStringValue = TextStyle(
    color: AppColors.grey900,
    fontSize: 48,
    fontFamily: AppFonts.avenirBook,
  );

  static const TextStyle biomarkerCardTrendLineValue = TextStyle(
    color: AppColors.grey900,
    fontSize: 20,
    fontFamily: AppFonts.avenirBook,
  );

  static const TextStyle biomarkerUnit = TextStyle(
    color: AppColors.grey600,
    fontSize: 14,
    fontFamily: AppFonts.avenirBook,
  );

  static const TextStyle biomarkerOptimalRange = TextStyle(
    color: AppColors.grey600,
    fontSize: 14,
    fontFamily: AppFonts.avenirBook,
  );

  static const TextStyle biomarkerNote = TextStyle(
    color: AppColors.grey600,
    fontSize: 14,
    fontFamily: AppFonts.avenirBook,
  );

  static const TextStyle biomarkerTrendLineHiddenPointsCount = TextStyle(
    color: AppColors.grey700,
    fontSize: 16,
    fontFamily: AppFonts.avenirMedium,
  );

  static const TextStyle biomarkerRangeIndicatorMinMaxValues = TextStyle(
    color: AppColors.grey600,
    fontSize: 14,
    fontFamily: AppFonts.avenirBook,
  );
}
