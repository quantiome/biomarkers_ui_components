import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;

extension NumExtension on num {
  double clampToDouble(num lowerLimit, num upperLimit) => clamp(lowerLimit, upperLimit).toDouble();

  int clampToInt(num lowerLimit, num upperLimit) => clamp(lowerLimit, upperLimit).toInt();

  /// Return the number as a String like '25.1' (if value is like 25.123...) or '25' (if value is like 25.0123...).
  String toStringPretty() => toStringAsFixed(1).replaceAll('.0', '');
}

extension DoubleExtension on double {
  /// Returns the value linearly transformed from [valueMin, valueMax] to [0, 1].
  double normalize(num valueMin, num valueMax) => distribute(
        targetMin: 0,
        targetMax: 1,
        valueMin: valueMin,
        valueMax: valueMax,
      );

  /// Returns the value linearly transformed from [valueMin, valueMax] to [targetMin, targetMax].
  /// Source: https://stats.stackexchange.com/questions/178626/how-to-normalize-data-between-1-and-1
  double distribute({
    required num targetMin,
    required num targetMax,
    required num valueMin,
    required num valueMax,
  }) {
    assert(valueMin != valueMax);
    return (targetMax - targetMin) * ((this - valueMin) / (valueMax - valueMin)) + targetMin;
  }
}

extension DateTimeExtension on DateTime {
  /// Returns the date formatted as AbbreviatedMonth Year (like "Sep 2021").
  String toAbrMonthAndYearString() => intl.DateFormat.yMMM().format(this);

  /// Return the date formatted as something like 2022-01-25.
  String toNumYearNumMonthNumDayString() => intl.DateFormat('yyy-MM-dd').format(this);
}

extension CanvasExtension on Canvas {
  /// Returns a [TextPainter] that can be used to paint some text.
  /// The TextPainter can be used to get the size of the text before it is painted.
  TextPainter layoutText({
    required String text,
    required TextStyle textStyle,
  }) {
    final TextSpan textSpan = TextSpan(
      text: text,
      style: textStyle,
    );

    final TextPainter textPainter = TextPainter(
      text: textSpan,
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    return textPainter;
  }

  /// Draw some text on the canvas.
  ///
  /// The [anchor] point determines what direction the text should be drawn from [textPosition].
  /// E.g. with the default [Alignment.topCenter] the [textPosition] will be above (top) the middle (center) of
  /// the text, which means the text will be drawn centered just under the [textPosition].
  ///
  /// Will autocorrect the position to make sure the text is not drawing out of the canvas if the given [textPosition]
  /// would make it do so.
  void drawText({
    required Size canvasSize,
    required TextPainter textPainter,
    required Offset textPosition,
    Alignment anchor = Alignment.topCenter,
  }) {
    final double textWidthOffset = textPainter.width * anchor.x.normalize(-1, 1);
    final double textHeightOffset = textPainter.height * anchor.y.normalize(-1, 1);
    final Offset correctedPosition = Offset(
      (textPosition.dx - textWidthOffset).clampToDouble(0, max(canvasSize.width - textPainter.width, 0)),
      (textPosition.dy - textHeightOffset).clampToDouble(0, max(canvasSize.height - textPainter.height, 0)),
    );

    textPainter.paint(
      this,
      correctedPosition,
    );
  }

  /// Convenience function to call [drawText] directly after [layoutText] (if you don't need to read any data from the [TextPainter]).
  ///
  /// See [drawText] and [layoutText].
  void layoutAndDrawText({
    required String text,
    required TextStyle textStyle,
    required Size canvasSize,
    required Offset textPosition,
    Alignment anchor = Alignment.topCenter,
  }) {
    final TextPainter textPainter = layoutText(
      text: text,
      textStyle: textStyle,
    );

    drawText(
      canvasSize: canvasSize,
      textPainter: textPainter,
      textPosition: textPosition,
      anchor: anchor,
    );
  }
}

extension PathExtension on Path {
  Path scaled(double scale) => transform(Matrix4.identity().scaled(scale).storage);
}
