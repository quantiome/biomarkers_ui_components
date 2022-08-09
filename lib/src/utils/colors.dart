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
  static const Color green500 = Color(0xFF55AC65);
  static const Color orange500 = Color(0xFFFF9800);
  static const Color red500 = Color(0xFFE94747);

  // Biomarker ranges
  static const Color biomarkerOptimal = green500;
  static const Color biomarkerBorderlineLow = gold;
  static const Color biomarkerBorderlineHigh = gold;
  static const Color biomarkerBadLow = orange500;
  static const Color biomarkerBadHigh = orange500;
  static const Color biomarkerVeryBadLow = red500;
  static const Color biomarkerVeryBadHigh = red500;
  static const Color biomarkerDefault = red500;
}
