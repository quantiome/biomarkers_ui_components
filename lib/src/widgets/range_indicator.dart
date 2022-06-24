import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/biomarker_number.dart';
import '../models/biomarker_validation_rule.dart';
import '../utils/colors.dart';
import '../utils/extensions.dart';
import 'arrow_head_path.dart';

class RangeIndicator extends StatelessWidget {
  static const double _arrowHorizontalSpace = 20;

  final double value;
  final double maxValue;
  final double minValue;
  final double? maxOptimalValue;
  final double? minOptimalValue;
  final double? maxBorderlineValue;
  final double? minBorderlineValue;
  final double? maxBadValue;
  final double? minBadValue;
  final double? maxVeryBadValue;
  final double? minVeryBadValue;
  final TextStyle textStyle;
  final Color barDefaultColor;
  final Color barOptimalColor;
  final Color barBorderlineHighColor;
  final Color barBorderlineLowColor;
  final Color barBadHighColor;
  final Color barBadLowColor;
  final Color barVeryBadHighColor;
  final Color barVeryBadLowColor;
  final Color cursorLineColor;
  final Color cursorTriangleColor;
  final double coloredBarWidth;

  Size get _painterSize => Size(_arrowHorizontalSpace + coloredBarWidth, 220);

  List<BiomarkerValidationRule> get _validationRules => BiomarkerNumber.getValidationRules(
        maxValue: maxValue,
        minValue: minValue,
        maxOptimalValue: maxOptimalValue,
        minOptimalValue: minOptimalValue,
        maxBorderlineValue: maxBorderlineValue,
        minBorderlineValue: minBorderlineValue,
        maxBadValue: maxBadValue,
        minBadValue: minBadValue,
        maxVeryBadValue: maxVeryBadValue,
        minVeryBadValue: minVeryBadValue,
      )..add(
          BiomarkerValidationRule(
            rule: () => value >= minValue && value <= maxValue,
            errorMessage: 'value must be in [minValue, maxValue] => $value ∉ [$minValue, $maxValue]',
          ),
        );

  /// The following rules must be respected:
  /// value ∈ [minValue, maxValue]
  /// If a BorderlineValue is not null then its corresponding OptimalValue must also be not null.
  /// Same for LowValue/HighValue and VeryLowValue/VeryHighValue, each higher range require all the previous ranges to be there.
  /// If a not null a BorderlineValue should always be above (for max) or below (for min) its corresponding OptimalValue.
  /// Same for LowValue/HighValue and VeryLowValue/VeryHighValue.
  /// A min should always be <= to its corresponding max.
  /// By default the whole bar is painted in [barDefaultColor].
  /// More colors are added based on the optional min/max values.
  ///
  /// When using [coloredBarWidth], keep in mind the whole drawing is scaled based on the size requirements given
  /// by the parent, so the actual bar width may not be [coloredBarWidth], but it will be proportional to it.
  RangeIndicator({
    Key? key,
    required this.value,
    required this.maxValue,
    required this.minValue,
    this.maxOptimalValue,
    this.minOptimalValue,
    this.maxBorderlineValue,
    this.minBorderlineValue,
    this.maxBadValue,
    this.minBadValue,
    this.maxVeryBadValue,
    this.minVeryBadValue,
    required this.textStyle,
    Color? barDefaultColor,
    Color? barOptimalColor,
    Color? barBorderlineHighColor,
    Color? barBorderlineLowColor,
    Color? barBadHighColor,
    Color? barBadLowColor,
    Color? barVeryBadHighColor,
    Color? barVeryBadLowColor,
    Color? cursorLineColor,
    Color? cursorTriangleColor,
    double? coloredBarWidth,
  })  : barDefaultColor = barDefaultColor ?? AppColors.biomarkerDefault,
        barOptimalColor = barOptimalColor ?? AppColors.biomarkerOptimal,
        barBorderlineHighColor = barBorderlineHighColor ?? AppColors.biomarkerBorderlineHigh,
        barBorderlineLowColor = barBorderlineLowColor ?? AppColors.biomarkerBorderlineLow,
        barBadHighColor = barBadHighColor ?? AppColors.biomarkerBadHigh,
        barBadLowColor = barBadLowColor ?? AppColors.biomarkerBadLow,
        barVeryBadHighColor = barVeryBadHighColor ?? AppColors.biomarkerVeryBadHigh,
        barVeryBadLowColor = barVeryBadLowColor ?? AppColors.biomarkerVeryBadLow,
        cursorLineColor = cursorLineColor ?? AppColors.grey700,
        cursorTriangleColor = cursorTriangleColor ?? AppColors.grey700,
        coloredBarWidth = coloredBarWidth ?? 46,
        super(key: key) {
    for (final BiomarkerValidationRule rule in _validationRules) {
      assert(rule.isRespected, rule.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) => FittedBox(
        child: SizedBox.fromSize(
          size: _painterSize,
          child: CustomPaint(
            size: _painterSize,
            painter: _Painter(
              value: value,
              maxValue: maxValue,
              minValue: minValue,
              maxOptimalValue: maxOptimalValue,
              minOptimalValue: minOptimalValue,
              maxBorderlineValue: maxBorderlineValue,
              minBorderlineValue: minBorderlineValue,
              maxBadValue: maxBadValue,
              minBadValue: minBadValue,
              maxVeryBadValue: maxVeryBadValue,
              minVeryBadValue: minVeryBadValue,
              textStyle: textStyle,
              barDefaultColor: barDefaultColor,
              barBorderlineHighColor: barBorderlineHighColor,
              barBorderlineLowColor: barBorderlineLowColor,
              barBadHighColor: barBadHighColor,
              barBadLowColor: barBadLowColor,
              barVeryBadHighColor: barVeryBadHighColor,
              barVeryBadLowColor: barVeryBadLowColor,
              barOptimalColor: barOptimalColor,
              cursorLineColor: cursorLineColor,
              cursorTriangleColor: cursorTriangleColor,
              coloredBarWidth: coloredBarWidth,
              validationRules: _validationRules,
            ),
          ),
        ),
      );
}

class _Painter extends CustomPainter {
  final double value;
  final double maxValue;
  final double minValue;
  final double? maxOptimalValue;
  final double? minOptimalValue;
  final double? maxBorderlineValue;
  final double? minBorderlineValue;
  final double? maxBadValue;
  final double? minBadValue;
  final double? maxVeryBadValue;
  final double? minVeryBadValue;
  final TextStyle textStyle;
  final Color barDefaultColor;
  final Color barOptimalColor;
  final Color barBorderlineHighColor;
  final Color barBorderlineLowColor;
  final Color barBadHighColor;
  final Color barBadLowColor;
  final Color barVeryBadHighColor;
  final Color barVeryBadLowColor;
  final Color cursorLineColor;
  final Color cursorTriangleColor;
  final double coloredBarWidth;
  final List<BiomarkerValidationRule> validationRules;

  const _Painter({
    required this.value,
    required this.maxValue,
    required this.minValue,
    required this.maxOptimalValue,
    required this.minOptimalValue,
    required this.maxBorderlineValue,
    required this.minBorderlineValue,
    required this.maxBadValue,
    required this.minBadValue,
    required this.maxVeryBadValue,
    required this.minVeryBadValue,
    required this.textStyle,
    required this.barDefaultColor,
    required this.barOptimalColor,
    required this.barBorderlineHighColor,
    required this.barBorderlineLowColor,
    required this.barBadHighColor,
    required this.barBadLowColor,
    required this.barVeryBadHighColor,
    required this.barVeryBadLowColor,
    required this.cursorLineColor,
    required this.cursorTriangleColor,
    required this.coloredBarWidth,
    required this.validationRules,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (validationRules.any((rule) => !rule.isRespected)) {
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

    void drawBarSection({
      required Color color,
      required double highValue,
      required double lowValue,
    }) {
      final Paint paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final double startHeight = getHeightForValue(highValue);
      final double endHeight = getHeightForValue(lowValue);

      final Rect rectangle = Rect.fromLTRB(
        leftSidePosition,
        startHeight,
        rightSidePosition,
        endHeight,
      );
      canvas.drawRect(rectangle, paint);
    }

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
      canvas.clipRRect(rectangle);
    }

    /// First paint the whole bar with [barDefaultColor], any other color will be painted on top.
    drawBarSection(
      color: barDefaultColor,
      highValue: maxValue,
      lowValue: minValue,
    );

    /// If [maxVeryBadValue] is not null draw the section from there down to [maxBadValue] with [barVeryBadHighColor].
    /// Requirement: if [maxVeryBadValue] is not null then [maxBadValue] should not be null either.
    if (maxVeryBadValue != null && maxBadValue != null) {
      drawBarSection(
        color: barVeryBadHighColor,
        highValue: maxVeryBadValue!,
        lowValue: maxBadValue!,
      );
    }

    /// If [maxBadValue] is not null draw the section from there down to [maxBorderlineValue] with [barBadHighColor].
    /// Requirement: if [maxBadValue] is not null then [maxBorderlineValue] should not be null either.
    if (maxBadValue != null && maxBorderlineValue != null) {
      drawBarSection(
        color: barBadHighColor,
        highValue: maxBadValue!,
        lowValue: maxBorderlineValue!,
      );
    }

    /// If [maxBorderlineValue] is not null draw the section from there down to [maxOptimalValue] with [barBorderlineHighColor].
    /// Requirement: if [maxBorderlineValue] is not null then [maxOptimalValue] should not be null either.
    if (maxBorderlineValue != null && maxOptimalValue != null) {
      drawBarSection(
        color: barBorderlineHighColor,
        highValue: maxBorderlineValue!,
        lowValue: maxOptimalValue!,
      );
    }

    /// If [maxOptimalValue] and [minOptimalValue] are not null draw the section
    /// from [maxOptimalValue] down to [minOptimalValue] with [barOptimalColor].
    if (maxOptimalValue != null && minOptimalValue != null) {
      drawBarSection(
        color: barOptimalColor,
        highValue: maxOptimalValue!,
        lowValue: minOptimalValue!,
      );
    }

    /// If [maxOptimalValue] is not null but [minOptimalValue] is null then draw the section
    /// from [maxOptimalValue] down to [minValue] with [barOptimalColor].
    if (maxOptimalValue != null && minOptimalValue == null) {
      drawBarSection(
        color: barOptimalColor,
        highValue: maxOptimalValue!,
        lowValue: minValue,
      );
    }

    /// If [minOptimalValue] is not null but [maxOptimalValue] is null then draw the section
    /// from [minOptimalValue] up to [maxValue] with [barOptimalColor].
    if (maxOptimalValue == null && minOptimalValue != null) {
      drawBarSection(
        color: barOptimalColor,
        highValue: maxValue,
        lowValue: minOptimalValue!,
      );
    }

    /// If [minBorderlineValue] is not null draw the section from [minOptimalValue] down to there with [barBorderlineLowColor].
    /// Requirement: if [minBorderlineValue] is not null then [minOptimalValue] should not be null either.
    if (minBorderlineValue != null && minOptimalValue != null) {
      drawBarSection(
        color: barBorderlineLowColor,
        highValue: minOptimalValue!,
        lowValue: minBorderlineValue!,
      );
    }

    /// If [minBadValue] is not null draw the section from [minBorderlineValue] down to there with [barBadLowColor].
    /// Requirement: if [minBadValue] is not null then [minBorderlineValue] should not be null either.
    if (minBadValue != null && minBorderlineValue != null) {
      drawBarSection(
        color: barBadLowColor,
        highValue: minBorderlineValue!,
        lowValue: minBadValue!,
      );
    }

    /// If [minVeryBadValue] is not null draw the section from [minBadValue] down to there with [barVeryBadLowColor].
    /// Requirement: if [minVeryBadValue] is not null then [minBadValue] should not be null either.
    if (minVeryBadValue != null && minBadValue != null) {
      drawBarSection(
        color: barVeryBadLowColor,
        highValue: minBadValue!,
        lowValue: minVeryBadValue!,
      );
    }

    /// Apply the clip.
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
      value != other.value ||
      maxValue != other.maxValue ||
      minValue != other.minValue ||
      maxOptimalValue != other.maxOptimalValue ||
      minOptimalValue != other.minOptimalValue ||
      maxBorderlineValue != other.maxBorderlineValue ||
      minBorderlineValue != other.minBorderlineValue ||
      maxBadValue != other.maxBadValue ||
      minBadValue != other.minBadValue ||
      maxVeryBadValue != other.maxVeryBadValue ||
      minVeryBadValue != other.minVeryBadValue ||
      textStyle != other.textStyle ||
      barDefaultColor != other.barDefaultColor ||
      barOptimalColor != other.barOptimalColor ||
      barBorderlineHighColor != other.barBorderlineHighColor ||
      barBorderlineLowColor != other.barBorderlineLowColor ||
      barBadHighColor != other.barBadHighColor ||
      barBadLowColor != other.barBadLowColor ||
      barVeryBadHighColor != other.barVeryBadHighColor ||
      barVeryBadLowColor != other.barVeryBadLowColor ||
      cursorLineColor != other.cursorLineColor ||
      cursorTriangleColor != other.cursorTriangleColor ||
      coloredBarWidth != other.coloredBarWidth;
}
