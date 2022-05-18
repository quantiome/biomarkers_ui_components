import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/extensions.dart';
import 'arrow_head_path.dart';

class BiomarkerRangeIndicator extends StatelessWidget {
  static const double _arrowHorizontalSpace = 20;

  final double maxValue;
  final double minValue;
  final double value;
  final Color barDefaultColor;
  final Color barOptimalColor;
  final Color barBorderlineColor;
  final Color cursorLineColor;
  final Color cursorTriangleColor;
  final TextStyle textStyle;
  final double? maxOptimalValue;
  final double? minOptimalValue;
  final double? maxBorderlineValue;
  final double? minBorderlineValue;
  final double coloredBarWidth;

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
  /// When using [coloredBarWidth], keep in mind the whole drawing is scaled based on the size requirements given
  /// by the parent, so the actual bar width may not be [coloredBarWidth], but it will be proportional to it.
  const BiomarkerRangeIndicator({
    Key? key,
    required this.maxValue,
    required this.minValue,
    required this.value,
    required this.textStyle,
    this.barDefaultColor = AppColors.grey400,
    this.barBorderlineColor = AppColors.gold,
    this.barOptimalColor = AppColors.purple500,
    this.cursorLineColor = AppColors.grey700,
    this.cursorTriangleColor = AppColors.grey700,
    this.maxOptimalValue,
    this.minOptimalValue,
    this.maxBorderlineValue,
    this.minBorderlineValue,
    this.coloredBarWidth = 46,
  })  : assert(minValue < maxValue),
        assert(
          value >= minValue && value <= maxValue,
          'value must be in [minValue, maxValue] => $value ∉ [$minValue, $maxValue]',
        ),
        assert(
          maxOptimalValue == null || maxOptimalValue >= minValue && maxOptimalValue <= maxValue,
          'maxOptimalValue (if not null) must be in [minValue, maxValue] => $maxOptimalValue ∉ [$minValue, $maxValue]',
        ),
        assert(
          minOptimalValue == null || minOptimalValue >= minValue && minOptimalValue <= maxValue,
          'minOptimalValue (if not null) must be in [minValue, maxValue] => $minOptimalValue ∉ [$minValue, $maxValue]',
        ),
        assert(
          maxOptimalValue == null || minOptimalValue == null || maxOptimalValue >= minOptimalValue,
          'If maxOptimalValue and minOptimalValue are both not null then maxOptimalValue'
          ' must be >= to minOptimalValue => maxOptimalValue = $maxOptimalValue, minOptimalValue = $minOptimalValue.',
        ),
        assert(
          maxBorderlineValue == null || maxBorderlineValue >= minValue && maxBorderlineValue <= maxValue,
          'maxBorderlineValue (if not null) must be in [minValue, maxValue] => $maxBorderlineValue ∉ [$minValue, $maxValue]',
        ),
        assert(
          minBorderlineValue == null || minBorderlineValue >= minValue && minBorderlineValue <= maxValue,
          'minBorderlineValue (if not null) must be in [minValue, maxValue] => $minBorderlineValue ∉ [$minValue, $maxValue]',
        ),
        assert(
          maxBorderlineValue == null || minBorderlineValue == null || maxBorderlineValue >= minBorderlineValue,
          'If maxBorderlineValue and minBorderlineValue are both not null then maxBorderlineValue'
          ' must be >= to minBorderlineValue => maxBorderlineValue = $maxBorderlineValue, minBorderlineValue = $minBorderlineValue.',
        ),
        assert(
          maxBorderlineValue == null || maxOptimalValue != null,
          'If maxBorderlineValue is non null then maxOptimalValue must also be non null.',
        ),
        assert(
          maxOptimalValue == null || maxBorderlineValue == null || maxBorderlineValue >= maxOptimalValue,
          'If maxOptimalValue and maxBorderlineValue are both not null then maxBorderlineValue'
          ' must be >= to maxOptimalValue => maxBorderlineValue = $maxBorderlineValue, maxOptimalValue = $maxOptimalValue.',
        ),
        assert(
          maxOptimalValue == null || minBorderlineValue == null || maxOptimalValue >= minBorderlineValue,
          'If maxOptimalValue and minBorderlineValue are both not null then maxOptimalValue'
          ' must be >= to minBorderlineValue => maxOptimalValue = $maxOptimalValue, minBorderlineValue = $minBorderlineValue.',
        ),
        assert(
          minBorderlineValue == null || minOptimalValue != null,
          'If minBorderlineValue is non null then minOptimalValue must also be non null.',
        ),
        assert(
          minOptimalValue == null || maxBorderlineValue == null || maxBorderlineValue >= minOptimalValue,
          'If minOptimalValue and maxBorderlineValue are both not null then maxBorderlineValue'
          ' must be >= to minOptimalValue => maxBorderlineValue = $maxBorderlineValue, minOptimalValue = $minOptimalValue.',
        ),
        assert(
          minOptimalValue == null || minBorderlineValue == null || minOptimalValue >= minBorderlineValue,
          'If minOptimalValue and minBorderlineValue are both not null then minOptimalValue'
          ' must be >= to minBorderlineValue => minOptimalValue = $minOptimalValue, minBorderlineValue = $minBorderlineValue.',
        ),
        assert(
          minOptimalValue == null || minBorderlineValue == null || minOptimalValue >= minBorderlineValue,
          'If minOptimalValue and minBorderlineValue are both not null then minOptimalValue'
          ' must be >= to minBorderlineValue => minOptimalValue = $minOptimalValue, minBorderlineValue = $minBorderlineValue.',
        ),
        super(key: key);

  Size get _painterSize => Size(_arrowHorizontalSpace + coloredBarWidth, 220);

  @override
  Widget build(BuildContext context) => FittedBox(
        child: SizedBox.fromSize(
          size: _painterSize,
          child: CustomPaint(
            size: _painterSize,
            painter: _Painter(
              maxValue: maxValue,
              minValue: minValue,
              value: value,
              textStyle: textStyle,
              barDefaultColor: barDefaultColor,
              barBorderlineColor: barBorderlineColor,
              barOptimalColor: barOptimalColor,
              cursorLineColor: cursorLineColor,
              cursorTriangleColor: cursorTriangleColor,
              maxOptimalValue: maxOptimalValue,
              minOptimalValue: minOptimalValue,
              maxBorderlineValue: maxBorderlineValue,
              minBorderlineValue: minBorderlineValue,
              coloredBarWidth: coloredBarWidth,
            ),
          ),
        ),
      );
}

class _Painter extends CustomPainter {
  final double maxValue;
  final double minValue;
  final double value;
  final TextStyle textStyle;
  final Color barDefaultColor;
  final Color barBorderlineColor;
  final Color barOptimalColor;
  final Color cursorLineColor;
  final Color cursorTriangleColor;
  final double? maxOptimalValue;
  final double? minOptimalValue;
  final double? maxBorderlineValue;
  final double? minBorderlineValue;
  final double coloredBarWidth;

  const _Painter({
    required this.maxValue,
    required this.minValue,
    required this.value,
    required this.textStyle,
    required this.barDefaultColor,
    required this.barBorderlineColor,
    required this.barOptimalColor,
    required this.cursorLineColor,
    required this.cursorTriangleColor,
    required this.maxOptimalValue,
    required this.minOptimalValue,
    required this.maxBorderlineValue,
    required this.minBorderlineValue,
    required this.coloredBarWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!(value >= minValue && value <= maxValue) ||
        !(maxOptimalValue == null || maxOptimalValue! >= minValue && maxOptimalValue! <= maxValue) ||
        !(minOptimalValue == null || minOptimalValue! >= minValue && minOptimalValue! <= maxValue) ||
        !(maxOptimalValue == null || minOptimalValue == null || maxOptimalValue! >= minOptimalValue!) ||
        !(maxBorderlineValue == null || maxBorderlineValue! >= minValue && maxBorderlineValue! <= maxValue) ||
        !(minBorderlineValue == null || minBorderlineValue! >= minValue && minBorderlineValue! <= maxValue) ||
        !(maxBorderlineValue == null || minBorderlineValue == null || maxBorderlineValue! >= minBorderlineValue!) ||
        !(maxBorderlineValue == null || maxOptimalValue != null) ||
        !(maxOptimalValue == null || maxBorderlineValue == null || maxBorderlineValue! >= maxOptimalValue!) ||
        !(maxOptimalValue == null || minBorderlineValue == null || maxOptimalValue! >= minBorderlineValue!) ||
        !(minBorderlineValue == null || minOptimalValue != null) ||
        !(minOptimalValue == null || maxBorderlineValue == null || maxBorderlineValue! >= minOptimalValue!) ||
        !(minOptimalValue == null || minBorderlineValue == null || minOptimalValue! >= minBorderlineValue!) ||
        !(minOptimalValue == null || minBorderlineValue == null || minOptimalValue! >= minBorderlineValue!)) {
      /// Invalid data.
      return;
    }

    final double maxTextHeight = _drawMaxText(canvas, size);
    final double minTextHeight = _drawMinText(canvas, size);

    /// The bar will size its height based on the available height.
    final double coloredBarHeight = size.height - (maxTextHeight + minTextHeight);

    _drawColoredBar(
      canvas: canvas,
      canvasSize: size,
      coloredBarHeight: coloredBarHeight,
      maxTextHeight: maxTextHeight,
    );

    _drawCursor(
      canvas: canvas,
      canvasSize: size,
      coloredBarHeight: coloredBarHeight,
      maxTextHeight: maxTextHeight,
    );
    // _drawMinMaxTexts(canvas, size, coloredBarHeight);
  }

  void _drawColoredBar({
    required Canvas canvas,
    required Size canvasSize,
    required double coloredBarHeight,
    required double maxTextHeight,
  }) {
    final double rightSidePosition = canvasSize.width;
    final double leftSidePosition = rightSidePosition - coloredBarWidth;
    final double topSidePosition = maxTextHeight;

    double getHeightForValue(double value) =>
        topSidePosition + coloredBarHeight * (1 - value.normalize(minValue, maxValue));

    {
      /// This will clip the bar to add the rounded corners.
      /// canvas.restore() must be called at the end of this function when the whole bar is drawn to apply the clip.
      canvas.save();
      final RRect rectangle = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          leftSidePosition,
          topSidePosition,
          rightSidePosition,
          topSidePosition + coloredBarHeight,
        ),
        const Radius.circular(4),
      );
      // canvas.drawRRect(rectangle, paint);
      canvas.clipRRect(rectangle);
    }

    {
      /// Draw the whole bar with [barDefaultColor].
      /// We will draw the other colors (if any) on top of it.
      final Paint paint = Paint()
        ..color = barDefaultColor
        ..style = PaintingStyle.fill;

      final RRect rectangle = RRect.fromRectAndRadius(
        Rect.fromLTRB(
          leftSidePosition,
          topSidePosition,
          rightSidePosition,
          topSidePosition + coloredBarHeight,
        ),
        const Radius.circular(4),
      );
      canvas.drawRRect(rectangle, paint);
    }

    {
      /// If [maxBorderlineValue] is not null draw the section from there down to [maxOptimalValue] with [barBorderlineColor].
      /// Requirement: if [maxBorderlineValue] is not null then [maxOptimalValue] should not be null either.
      if (maxBorderlineValue != null && maxOptimalValue != null) {
        final Paint paint = Paint()
          ..color = barBorderlineColor
          ..style = PaintingStyle.fill;

        final double startHeight = getHeightForValue(maxBorderlineValue!);
        final double endHeight = getHeightForValue(maxOptimalValue!);

        final Rect rectangle = Rect.fromLTRB(
          leftSidePosition,
          startHeight,
          rightSidePosition,
          endHeight,
        );
        canvas.drawRect(rectangle, paint);
      }
    }

    {
      /// If [minBorderlineValue] is not null draw the section from [minOptimalValue] down to there with [barBorderlineColor].
      /// Requirement: if [minBorderlineValue] is not null then [minOptimalValue] should not be null either.
      if (minBorderlineValue != null && minOptimalValue != null) {
        final Paint paint = Paint()
          ..color = barBorderlineColor
          ..style = PaintingStyle.fill;

        final double startHeight = getHeightForValue(minOptimalValue!);
        final double endHeight = getHeightForValue(minBorderlineValue!);

        final Rect rectangle = Rect.fromLTRB(
          leftSidePosition,
          startHeight,
          rightSidePosition,
          endHeight,
        );
        canvas.drawRect(rectangle, paint);
      }
    }

    {
      /// If [maxOptimalValue] and [minOptimalValue] are not null draw the section
      /// from [maxOptimalValue] down to [minOptimalValue] with [barOptimalColor].
      if (maxOptimalValue != null && minOptimalValue != null) {
        final Paint paint = Paint()
          ..color = barOptimalColor
          ..style = PaintingStyle.fill;

        final double startHeight = getHeightForValue(maxOptimalValue!);
        final double endHeight = getHeightForValue(minOptimalValue!);

        final Rect rectangle = Rect.fromLTRB(
          leftSidePosition,
          startHeight,
          rightSidePosition,
          endHeight,
        );
        canvas.drawRect(rectangle, paint);
      }
    }

    {
      /// If [maxOptimalValue] is not null but [minOptimalValue] is null then draw the section
      /// from [maxOptimalValue] down to [minValue] with [barOptimalColor].
      if (maxOptimalValue != null && minOptimalValue == null) {
        final Paint paint = Paint()
          ..color = barOptimalColor
          ..style = PaintingStyle.fill;

        final double startHeight = getHeightForValue(maxOptimalValue!);
        final double endHeight = topSidePosition + coloredBarHeight;

        final Rect rectangle = Rect.fromLTRB(
          leftSidePosition,
          startHeight,
          rightSidePosition,
          endHeight,
        );
        canvas.drawRect(rectangle, paint);
      }
    }

    {
      /// If [minOptimalValue] is not null but [maxOptimalValue] is null then draw the section
      /// from [minOptimalValue] up to [maxValue] with [barOptimalColor].
      if (maxOptimalValue == null && minOptimalValue != null) {
        final Paint paint = Paint()
          ..color = barOptimalColor
          ..style = PaintingStyle.fill;

        final double startHeight = topSidePosition;
        final double endHeight = getHeightForValue(minOptimalValue!);

        final Rect rectangle = Rect.fromLTRB(
          leftSidePosition,
          startHeight,
          rightSidePosition,
          endHeight,
        );
        canvas.drawRect(rectangle, paint);
      }
    }

    canvas.restore();
  }

  void _drawCursor({
    required Canvas canvas,
    required Size canvasSize,
    required double coloredBarHeight,
    required double maxTextHeight,
  }) {
    /// The cursor bar extends a little bit past the colored rectangle left side.
    const double extentLeftOfColoredBar = 1.5;
    const double strokeWidth = 2;

    final Paint paint = Paint()
      ..color = cursorLineColor
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final double valueRatio = value.normalize(minValue, maxValue);

    /// The line is drawn with some strokeWidth, which will be on both side of the line we give to [canvas.drawLine].
    /// To avoid the line drawing out of the bar when at the min or max we need to add some correction.
    final double lineHeightStrokeWidthCorrection = value.distribute(
      targetMin: -strokeWidth * 0.5,
      targetMax: strokeWidth * 0.5,
      valueMin: minValue,
      valueMax: maxValue,
    );

    /// Using (1 - valueRatio) rather than just [valueRatio] because the origin for drawing is top (left), and the [minValue]
    /// needs to be drawn at the bottom.
    final double lineHeight = maxTextHeight + coloredBarHeight * (1 - valueRatio) + lineHeightStrokeWidthCorrection;

    final Offset lineStartPoint = Offset(
      canvasSize.width - coloredBarWidth - extentLeftOfColoredBar,
      lineHeight,
    );
    final Offset lineEndPoint = Offset(
      canvasSize.width - strokeWidth * 0.5,
      lineHeight,
    );

    canvas.drawLine(lineStartPoint, lineEndPoint, paint);

    /// Draw triangle
    final Path trianglePath = ArrowHeadPath.right.shift(Offset(0, lineHeight));
    paint.color = cursorTriangleColor;
    canvas.drawPath(trianglePath, paint);
  }

  /// Returns the text's height.
  double _drawMaxText(
    Canvas canvas,
    Size canvasSize,
  ) {
    final TextPainter textPainter = canvas.layoutText(
      text: maxValue.toStringPretty(),
      textStyle: textStyle,
    );

    final Offset textPosition = Offset(
      canvasSize.width - coloredBarWidth * 0.5,
      0,
    );

    canvas.drawText(
      canvasSize: canvasSize,
      textPainter: textPainter,
      textPosition: textPosition,
      anchor: Alignment.topCenter,
    );

    return textPainter.height;
  }

  /// Returns the text's height.
  double _drawMinText(
    Canvas canvas,
    Size canvasSize,
  ) {
    final TextPainter textPainter = canvas.layoutText(
      text: minValue.toStringPretty(),
      textStyle: textStyle,
    );

    final Offset textPosition = Offset(
      canvasSize.width - coloredBarWidth * 0.5,
      canvasSize.height,
    );

    canvas.drawText(
      canvasSize: canvasSize,
      textPainter: textPainter,
      textPosition: textPosition,
      anchor: Alignment.bottomCenter,
    );

    return textPainter.height;
  }

  @override
  bool shouldRepaint(_Painter other) =>
      maxValue != other.maxValue ||
      minValue != other.minValue ||
      value != other.value ||
      barDefaultColor != other.barDefaultColor ||
      barOptimalColor != other.barOptimalColor ||
      barBorderlineColor != other.barBorderlineColor ||
      cursorLineColor != other.cursorLineColor ||
      cursorTriangleColor != other.cursorTriangleColor ||
      textStyle != other.textStyle ||
      maxOptimalValue != other.maxOptimalValue ||
      minOptimalValue != other.minOptimalValue ||
      maxBorderlineValue != other.maxBorderlineValue ||
      minBorderlineValue != other.minBorderlineValue ||
      coloredBarWidth != other.coloredBarWidth;
}
