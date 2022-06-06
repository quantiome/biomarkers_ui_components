import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';

@immutable
class TrendLinePoint implements Comparable<TrendLinePoint> {
  final double value;
  final DateTime time;
  final Color color;

  const TrendLinePoint({
    required this.value,
    required this.time,
    this.color = AppColors.purple500,
  });

  @override
  int compareTo(TrendLinePoint other) {
    if (other.time == time) {
      return 0;
    }

    return time.isBefore(other.time) ? -1 : 1;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TrendLinePoint &&
          runtimeType == other.runtimeType &&
          value == other.value &&
          time == other.time &&
          color == other.color;

  @override
  int get hashCode => value.hashCode ^ time.hashCode ^ color.hashCode;
}
