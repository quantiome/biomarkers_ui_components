import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/trend_line_point.dart';
import '../utils/extensions.dart';
import 'arrow_head_path.dart';

class TrendLine extends StatelessWidget {
  static const Size painterSize = Size(300, 150);

  final List<TrendLinePoint> points;
  final int maxPointsToDisplayCount;
  final TextStyle valueTextStyle;
  final TextStyle dateTextStyle;
  final TextStyle hiddenPointsCountTextStyle;
  final DateFormat? dateFormat;
  final double dotRadius;
  final double linesStrokeWidth;

  const TrendLine({
    Key? key,
    required this.points,
    int? maxPointsToDisplayCount,
    required this.valueTextStyle,
    required this.dateTextStyle,
    required this.hiddenPointsCountTextStyle,
    this.dateFormat,
    double? dotRadius,
    double? linesStrokeWidth,
  })  : maxPointsToDisplayCount = maxPointsToDisplayCount ?? 3,
        dotRadius = dotRadius ?? 16,
        linesStrokeWidth = linesStrokeWidth ?? 8,
        assert(points.length >= 2),
        assert(
          maxPointsToDisplayCount == null || maxPointsToDisplayCount >= 2,
          'maxPointsToDisplayCount must be at least 2.',
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) => FittedBox(
        child: SizedBox.fromSize(
          size: painterSize,
          child: CustomPaint(
            size: painterSize,
            painter: _Painter(
              points: points,
              maxPointsToDisplayCount: maxPointsToDisplayCount,
              valueTextStyle: valueTextStyle,
              dateTextStyle: dateTextStyle,
              hiddenPointsCountTextStyle: hiddenPointsCountTextStyle,
              dateFormat: dateFormat,
              dotRadius: dotRadius,
              linesStrokeWidth: linesStrokeWidth,
            ),
          ),
        ),
      );
}

class _Painter extends CustomPainter {
  static const double _pointsAvailableHeight = 80;

  late final List<TrendLinePoint> points;
  late final List<TrendLinePoint> pointsToDisplay;

  /// We will only show at max this number of points at a time.
  final int maxPointsToDisplayCount;
  final TextStyle valueTextStyle;
  final TextStyle dateTextStyle;
  final TextStyle hiddenPointsCountTextStyle;
  final DateFormat? dateFormat;
  final double dotRadius;
  final double linesStrokeWidth;

  /// The edge points (left and right) will be drawn that distance away from the edges of the painter.
  late final double _pointsHorizontalPadding;
  late final int _hiddenPointsCount;
  late final double _minRange;
  late final double _maxRange;

  _Painter({
    required List<TrendLinePoint> points,
    required this.maxPointsToDisplayCount,
    required this.valueTextStyle,
    required this.dateTextStyle,
    required this.hiddenPointsCountTextStyle,
    required this.dateFormat,
    required this.dotRadius,
    required this.linesStrokeWidth,
  }) {
    this.points = points..sort((a, b) => a.time.isBefore(b.time) ? -1 : 1);
    _hiddenPointsCount = (points.length - maxPointsToDisplayCount).clampToInt(0, points.length);
    pointsToDisplay = this.points.skip((points.length - maxPointsToDisplayCount).clampToInt(0, points.length)).toList();
    _minRange = pointsToDisplay.fold(
      double.infinity,
      (previousValue, element) => element.value < previousValue ? element.value : previousValue,
    );
    _maxRange = pointsToDisplay.fold(
      -double.infinity,
      (previousValue, element) => element.value > previousValue ? element.value : previousValue,
    );
    _pointsHorizontalPadding = 42 + dotRadius;
  }

  List<_Point> _computePoints(Size canvasSize) {
    final double pointsSpacing = (canvasSize.width - 2 * _pointsHorizontalPadding) / (pointsToDisplay.length - 1);
    return List<_Point>.generate(
      pointsToDisplay.length,
      (index) {
        final double yRatio = pointsToDisplay[index].value.normalize(_minRange, _maxRange);
        final double xPosition = _pointsHorizontalPadding + pointsSpacing * index;

        /// Using (1 - yRatio) rather than just [yRatio] because the origin for drawing is top (left), and the [minValue]
        /// needs to be drawn at the bottom.
        final double yPosition = dotRadius + (_pointsAvailableHeight - dotRadius) * (1 - yRatio);

        final Offset position = Offset(xPosition, yPosition);

        return _Point._fromTrendLinePoint(
          pointsToDisplay[index],
          position,
        );
      },
    );
  }

  @override
  void paint(Canvas canvas, Size size) {
    List<_Point> processedPoints = _computePoints(size);

    _drawLinks(
      canvas: canvas,
      processedPoints: processedPoints,
    );

    if (_hiddenPointsCount != 0) {
      _drawMoreArrow(
        canvas: canvas,
        canvasSize: size,
        firstPoint: processedPoints.first,
      );
    }

    _drawCircles(
      canvas: canvas,
      processedPoints: processedPoints,
    );

    _drawTexts(
      canvas: canvas,
      canvasSize: size,
      processedPoints: processedPoints,
    );
  }

  void _drawLinks({
    required Canvas canvas,
    required List<_Point> processedPoints,
  }) {
    for (int i = 1; i < processedPoints.length; i++) {
      _drawLink(
        canvas: canvas,
        startPoint: processedPoints[i - 1],
        endPoint: processedPoints[i],
      );
    }
  }

  void _drawLink({
    required Canvas canvas,
    required _Point startPoint,
    required _Point endPoint,
  }) {
    final Paint paint = Paint()
      ..shader = LinearGradient(colors: [startPoint.color, endPoint.color]).createShader(
        Rect.fromPoints(

            /// Adding some translation here because we want the gradient to start just after the first circle edge and
            /// end just before the next circle edge (to have a smooth junction).
            startPoint.position.translate(dotRadius, 0),
            endPoint.position.translate(-dotRadius, 0)),
      )
      ..strokeWidth = linesStrokeWidth
      ..strokeCap = StrokeCap.square;

    canvas.drawLine(startPoint.position, endPoint.position, paint);
  }

  void _drawMoreArrow({
    required Canvas canvas,
    required Size canvasSize,
    required _Point firstPoint,
  }) {
    final Paint paint = Paint()
      ..color = firstPoint.color
      ..strokeWidth = linesStrokeWidth
      ..strokeCap = StrokeCap.butt;

    /// We need to manually draw a dashed line bits by bits.
    /// Always draw a block (colored section) from the circle side.
    /// Always have a gap before the arrow head.

    const double textToArrowVerticalPadding = 3;
    const double arrowHeadHeight = 14;
    const double arrowHeadScale = arrowHeadHeight / ArrowHeadPath.height;
    const double arrowHeadWidth = arrowHeadScale * ArrowHeadPath.width;
    final double gapWidth = linesStrokeWidth * 0.5;
    final double blockWidth = linesStrokeWidth * 0.5;

    /// A "segment" is a block followed by a gap (keeping in mind the orientation is right to left).
    final double segmentWidth = gapWidth + blockWidth;
    final double lineLength = firstPoint.position.dx - dotRadius - arrowHeadWidth + blockWidth;
    final int blocksCount = lineLength ~/ (gapWidth + blockWidth);
    final Offset lineStartPoint = firstPoint.position.translate(-dotRadius, 0);

    /// We "extend" the first block to the inside of the circle to avoid seeing a gap at the circle curve.
    canvas.drawLine(
      lineStartPoint,
      lineStartPoint.translate(dotRadius, 0),
      paint,
    );

    for (int i = 0; i < blocksCount; i++) {
      final Offset segmentStart = lineStartPoint.translate(-(i * segmentWidth), 0);
      canvas.drawLine(
        segmentStart,
        segmentStart.translate(-blockWidth, 0),
        paint,
      );
    }

    /// Draw arrow head
    final Path arrowHead = ArrowHeadPath.left.scaled(arrowHeadScale).shift(Offset(0, lineStartPoint.dy));
    canvas.drawPath(arrowHead, paint);

    /// Draw text
    final TextPainter textPainter = canvas.layoutText(
      text: '+$_hiddenPointsCount',
      textStyle: hiddenPointsCountTextStyle,
    );

    double textYPosition = lineStartPoint.dy - arrowHeadHeight * 0.5 - textToArrowVerticalPadding;
    Alignment textAnchor = Alignment.bottomLeft;
    if (textYPosition - textPainter.height < 0) {
      /// Draw the text under the arrow if it is too close to the top edge.
      textYPosition = lineStartPoint.dy + arrowHeadHeight * 0.5 + textToArrowVerticalPadding;
      textAnchor = Alignment.topLeft;
    }

    canvas.drawText(
      canvasSize: canvasSize,
      textPainter: textPainter,
      textPosition: Offset(0, textYPosition),
      anchor: textAnchor,
    );
  }

  void _drawCircles({
    required Canvas canvas,
    required List<_Point> processedPoints,
  }) {
    for (final point in processedPoints) {
      _drawCircle(
        canvas: canvas,
        point: point,
      );
    }
  }

  void _drawCircle({
    required Canvas canvas,
    required _Point point,
  }) {
    final Paint paint = Paint()
      ..color = point.color
      ..style = PaintingStyle.fill;

    canvas.drawCircle(point.position, dotRadius, paint);
  }

  void _drawTexts({
    required Canvas canvas,
    required Size canvasSize,
    required List<_Point> processedPoints,
  }) {
    for (final point in processedPoints) {
      _drawText(
        canvas: canvas,
        canvasSize: canvasSize,
        point: point,
      );
    }
  }

  void _drawText({
    required Canvas canvas,
    required Size canvasSize,
    required _Point point,
  }) {
    final double valueToDotVerticalPadding = dotRadius + 5;

    /// Draw date
    final TextPainter dateTextPainter = canvas.layoutText(
      text: dateFormat?.format(point.time) ?? point.time.toAbrMonthAndYearString(),
      textStyle: dateTextStyle,
    );

    canvas.drawText(
      canvasSize: canvasSize,
      textPainter: dateTextPainter,
      textPosition: Offset(point.position.dx, canvasSize.height),
      anchor: Alignment.bottomCenter,
    );

    /// Draw value
    final TextPainter valueTextPainter = canvas.layoutText(
      text: point.value.toStringPretty(),
      textStyle: valueTextStyle,
    );

    double valueTextYPosition = point.position.dy - valueToDotVerticalPadding;
    Alignment textAnchor = Alignment.bottomCenter;
    if (valueTextYPosition - valueTextPainter.height < 0) {
      /// Draw the text under the dot if it is too close to the top edge.
      valueTextYPosition = point.position.dy + valueToDotVerticalPadding;
      textAnchor = Alignment.topCenter;
    }

    canvas.drawText(
      canvasSize: canvasSize,
      textPainter: valueTextPainter,
      textPosition: Offset(point.position.dx, valueTextYPosition),
      anchor: textAnchor,
    );
  }

  @override
  bool shouldRepaint(_Painter other) {
    if (maxPointsToDisplayCount != other.maxPointsToDisplayCount) {
      return true;
    }

    if (points.length != other.points.length) {
      return true;
    }

    for (int i = 0; i < points.length; i++) {
      if (points[i] != other.points[i]) {
        return true;
      }
    }

    return false;
  }
}

@immutable
class _Point {
  final double value;
  final DateTime time;
  final Offset position;
  final Color color;

  const _Point({
    required this.value,
    required this.time,
    required this.position,
    required this.color,
  });

  factory _Point._fromTrendLinePoint(
    TrendLinePoint point,
    Offset position,
  ) =>
      _Point(
        value: point.value,
        time: point.time,
        position: position,
        color: point.color,
      );
}
