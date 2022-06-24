import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/biomarker_number.dart';
import 'range_indicator.dart';

/// Convenience class to display a [RangeIndicator] using a [BiomarkerNumber].
class BiomarkerRangeIndicator extends StatelessWidget {
  final BiomarkerNumber biomarker;
  final TextStyle textStyle;
  final Color? barDefaultColor;
  final Color? barOptimalColor;
  final Color? barBorderlineColor;
  final Color? barBadColor;
  final Color? barVeryBadColor;
  final Color? cursorLineColor;
  final Color? cursorTriangleColor;
  final double? coloredBarWidth;

  /// We clamp the value before displaying it in the [RangeIndicator].
  double get value => biomarker.value < biomarker.minValue
      ? biomarker.minValue
      : biomarker.value > biomarker.maxValue
          ? biomarker.maxValue
          : biomarker.value;

  const BiomarkerRangeIndicator({
    Key? key,
    required this.biomarker,
    required this.textStyle,
    this.barDefaultColor,
    this.barOptimalColor,
    this.barBorderlineColor,
    this.barBadColor,
    this.barVeryBadColor,
    this.cursorLineColor,
    this.cursorTriangleColor,
    this.coloredBarWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => RangeIndicator(
        value: value,
        maxValue: biomarker.maxValue,
        minValue: biomarker.minValue,
        maxOptimalValue: biomarker.maxOptimalValue,
        minOptimalValue: biomarker.minOptimalValue,
        maxBorderlineValue: biomarker.maxBorderlineValue,
        minBorderlineValue: biomarker.minBorderlineValue,
        maxBadValue: biomarker.maxBadValue,
        minBadValue: biomarker.minBadValue,
        maxVeryBadValue: biomarker.maxVeryBadValue,
        minVeryBadValue: biomarker.minVeryBadValue,
        textStyle: textStyle,
        barDefaultColor: barDefaultColor,
        barOptimalColor: barOptimalColor,
        barBorderlineHighColor: barBorderlineColor,
        barBorderlineLowColor: barBorderlineColor,
        barBadHighColor: barBadColor,
        barBadLowColor: barBadColor,
        barVeryBadHighColor: barVeryBadColor,
        barVeryBadLowColor: barVeryBadColor,
        cursorLineColor: cursorLineColor,
        cursorTriangleColor: cursorTriangleColor,
        coloredBarWidth: coloredBarWidth,
      );
}
