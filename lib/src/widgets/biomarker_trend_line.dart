import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/biomarker_number.dart';
import '../models/trend_line_point.dart';
import 'trend_line.dart';

/// Convenience class to display a [TrendLine] using [BiomarkerNumber].
class BiomarkerTrendLine extends StatelessWidget {
  final List<BiomarkerNumber> biomarkers;
  final int? maxPointsToDisplayCount;
  final TextStyle valueTextStyle;
  final TextStyle dateTextStyle;
  final TextStyle hiddenPointsCountTextStyle;

  const BiomarkerTrendLine({
    Key? key,
    required this.biomarkers,
    this.maxPointsToDisplayCount,
    required this.valueTextStyle,
    required this.dateTextStyle,
    required this.hiddenPointsCountTextStyle,
  }) : super(key: key);

  List<TrendLinePoint> get _points => biomarkers
      .map(
        (biomarker) => TrendLinePoint(
          value: biomarker.value,
          time: biomarker.time,
          color: biomarker.color,
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) => TrendLine(
        points: _points,
        maxPointsToDisplayCount: maxPointsToDisplayCount,
        valueTextStyle: valueTextStyle,
        dateTextStyle: dateTextStyle,
        hiddenPointsCountTextStyle: hiddenPointsCountTextStyle,
      );
}
