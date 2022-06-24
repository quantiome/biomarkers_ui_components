import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color purple500 = Color(0xFFB849E5);
  static const Color grey900 = Color(0xFF081629);
  static const Color grey700 = Color(0xFF3F4650);
  static const Color grey600 = Color(0xFF6C7889);
  static const Color grey400 = Color(0xFFAEBED7);
  static const Color gold = Color(0xFFFFCD00);
  static const Color yellow1 = Color(0xFFFFE195);
  static const Color yellow2 = Color(0xFFFFD466);
  static const Color red = Color(0xFFFF9595);

  // Biomarker ranges
  static const Color biomarkerOptimal = purple500;
  static const Color biomarkerBorderlineLow = yellow1;
  static const Color biomarkerBorderlineHigh = yellow1;
  static const Color biomarkerBadLow = yellow2;
  static const Color biomarkerBadHigh = yellow2;
  static const Color biomarkerVeryBadLow = red;
  static const Color biomarkerVeryBadHigh = red;
  static const Color biomarkerDefault = grey400;
}
