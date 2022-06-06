import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  const TrendLine({
    Key? key,
    required this.points,
    int? maxPointsToDisplayCount,
    required this.valueTextStyle,
    required this.dateTextStyle,
    required this.hiddenPointsCountTextStyle,
  })  : maxPointsToDisplayCount = maxPointsToDisplayCount ?? 3,
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
            ),
          ),
        ),
      );
}

class _Painter extends CustomPainter {
  /// We will only show max this number of points at a time.
  static const double _pointsRadius = 16;
  static const double _pointsAvailableHeight = 80;
  static const double _linesStrokeWidth = 8;

  /// The edge points will be drawn that away distance to the edges of the painter.
  static const double _pointsHorizontalPadding = 42 + _pointsRadius;

  late final List<TrendLinePoint> points;
  late final List<TrendLinePoint> pointsToDisplay;
  final int maxPointsToDisplayCount;
  late final int hiddenPointsCount;
  late final double minRange;
  late final double maxRange;
  final TextStyle valueTextStyle;
  final TextStyle dateTextStyle;
  final TextStyle hiddenPointsCountTextStyle;

  _Painter({
    required List<TrendLinePoint> points,
    required this.maxPointsToDisplayCount,
    required this.valueTextStyle,
    required this.dateTextStyle,
    required this.hiddenPointsCountTextStyle,
  }) {
    this.points = points..sort((a, b) => a.time.isBefore(b.time) ? -1 : 1);
    hiddenPointsCount = (points.length - maxPointsToDisplayCount).clampToInt(0, points.length);
    pointsToDisplay = this.points.skip((points.length - maxPointsToDisplayCount).clampToInt(0, points.length)).toList();
    minRange = pointsToDisplay.fold(
      double.infinity,
      (previousValue, element) => element.value < previousValue ? element.value : previousValue,
    );
    maxRange = pointsToDisplay.fold(
      -double.infinity,
      (previousValue, element) => element.value > previousValue ? element.value : previousValue,
    );
  }

  List<_Point> _computePoints(Size canvasSize) {
    final double pointsSpacing = (canvasSize.width - 2 * _pointsHorizontalPadding) / (pointsToDisplay.length - 1);
    return List<_Point>.generate(
      pointsToDisplay.length,
      (index) {
        final double yRatio = pointsToDisplay[index].value.normalize(minRange, maxRange);
        final double xPosition = _pointsHorizontalPadding + pointsSpacing * index;

        /// Using (1 - yRatio) rather than just [yRatio] because the origin for drawing is top (left), and the [minValue]
        /// needs to be drawn at the bottom.
        final double yPosition = _pointsRadius + (_pointsAvailableHeight - _pointsRadius) * (1 - yRatio);

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

    _drawMoreArrow(
      canvas: canvas,
      canvasSize: size,
      firstPoint: processedPoints.first,
    );

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
            startPoint.position.translate(_pointsRadius, 0),
            endPoint.position.translate(-_pointsRadius, 0)),
      )
      ..strokeWidth = _linesStrokeWidth
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
      ..strokeWidth = _linesStrokeWidth
      ..strokeCap = StrokeCap.butt;

    /// We need to manually draw a dashed line bits by bits.
    /// Always draw a block (colored section) from the circle side.
    /// Always have a gap before the arrow head.

    const double textToArrowVerticalPadding = 3;
    const double arrowHeadHeight = 14;
    const double arrowHeadScale = arrowHeadHeight / ArrowHeadPath.height;
    const double arrowHeadWidth = arrowHeadScale * ArrowHeadPath.width;
    const double gapWidth = _linesStrokeWidth * 0.5;
    const double blockWidth = _linesStrokeWidth * 0.5;

    /// A "segment" is a block followed by a gap (keeping in mind the orientation is right to left).
    const double segmentWidth = gapWidth + blockWidth;
    final double lineLength = firstPoint.position.dx - _pointsRadius - arrowHeadWidth + blockWidth;
    final int blocksCount = lineLength ~/ (gapWidth + blockWidth);
    final Offset lineStartPoint = firstPoint.position.translate(-_pointsRadius, 0);

    /// We "extend" the first block to the inside of the circle to avoid seeing a gap at the circle curve.
    canvas.drawLine(
      lineStartPoint,
      lineStartPoint.translate(_pointsRadius, 0),
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
    canvas.layoutAndDrawText(
      text: '+$hiddenPointsCount',
      textStyle: hiddenPointsCountTextStyle,
      canvasSize: canvasSize,
      textPosition: Offset(0, lineStartPoint.dy - arrowHeadHeight * 0.5 - textToArrowVerticalPadding),
      anchor: Alignment.bottomLeft,
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

    canvas.drawCircle(point.position, _pointsRadius, paint);
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
    const double valueToDateVerticalPadding = 5;

    final TextPainter dateTextPainter = canvas.layoutText(
      text: point.time.toAbrMonthAndYearString(),
      textStyle: dateTextStyle,
    );

    canvas.drawText(
      canvasSize: canvasSize,
      textPainter: dateTextPainter,
      textPosition: Offset(point.position.dx, canvasSize.height),
      anchor: Alignment.bottomCenter,
    );

    canvas.layoutAndDrawText(
      text: '${point.value}',
      canvasSize: canvasSize,
      textStyle: valueTextStyle,
      textPosition: Offset(point.position.dx, canvasSize.height - valueToDateVerticalPadding - dateTextPainter.height),
      anchor: Alignment.bottomCenter,
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
