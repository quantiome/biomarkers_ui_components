import 'dart:math';

import 'package:flutter/rendering.dart';

abstract class ArrowHeadPath {
  /// Draw a triangle (arrow head).
  /// The origin of the is at the opposite of the tip (i.e. center of the vertical segment).
  /// The triangle path was generate from an online tool from the SVG file:
  /// https://www.flutterclutter.dev/tools/svg-to-flutter-path-converter/
  static const double width = 11;
  static const double height = 21;

  /// This value (empirical) is to align the tip of the triangle and the cursor line. It is needed because the SVG is not perfect.
  static const double _empiricalAlignmentCorrection = height * (1.5 / 21);

  static final Path right = _path;

  static final Path left = _path
      .transform(
        Matrix4.rotationY(pi).storage,
      )
      .shift(
        const Offset(width, 0),
      );

  static final Path _path = (Path()
        ..lineTo(
          0,
          height,
        )
        ..cubicTo(
          0,
          height * 1.05,
          width * 0.13,
          height * 1.08,
          width / 5,
          height * 1.03,
        )
        ..cubicTo(
          width / 5,
          height * 1.03,
          width * 0.96,
          height * 0.6,
          width * 0.96,
          height * 0.6,
        )
        ..cubicTo(
          width,
          height * 0.58,
          width,
          height * 0.53,
          width * 0.96,
          height * 0.51,
        )
        ..cubicTo(
          width * 0.96,
          height * 0.51,
          width / 5,
          height * 0.08,
          width / 5,
          height * 0.08,
        )
        ..cubicTo(
          width * 0.13,
          height * 0.03,
          0,
          height * 0.06,
          0,
          height * 0.12,
        )
        ..cubicTo(
          0,
          height * 0.12,
          0,
          height,
          0,
          height,
        )
        ..cubicTo(
          0,
          height,
          0,
          height,
          0,
          height,
        ))
      .shift(
    const Offset(
      0,
      -height * 0.5 - _empiricalAlignmentCorrection,
    ),
  );
}
