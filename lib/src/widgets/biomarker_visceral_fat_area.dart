import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../models/biomarker_number.dart';
import '../utils/assets.dart';
import '../utils/extensions.dart';
import '../utils/text_styles.dart';

/// Meant to display a biomarker of type Visceral Fat Area with a special UI.
/// In reality it can display the special UI with any [BiomarkerNumber], it's the caller responsibility to feed the
/// right biomarker type.
class BiomarkerVisceralFatArea extends StatelessWidget {
  static const double _reticleSize = 24;

  final BiomarkerNumber visceralFatArea;
  final double userAge;

  const BiomarkerVisceralFatArea({
    Key? key,
    required this.visceralFatArea,
    required this.userAge,
  }) : super(key: key);

  Widget _buildReticle(double imageWidth) {
    /// Values are taken from image file.
    const double imageHeightWidthRatio = 80.911 / 111.4;
    const double imageOriginWidthRatio = 0.093;
    const double imageOriginHeightRatio = 0.9;
    final double imageHeight = imageWidth * imageHeightWidthRatio;
    const double imageXUnitWidthRatio = 0.00890;
    const double imageYUnitHeightRatio = 0.00428;

    double reticleX = imageWidth * (imageOriginWidthRatio + imageXUnitWidthRatio * userAge) - _reticleSize * 0.5;
    double reticleY =
        imageHeight * (imageOriginHeightRatio - imageYUnitHeightRatio * visceralFatArea.value) - _reticleSize * 0.5;

    /// Cap max X and Y to avoid going out of the image.
    if (reticleX > imageWidth * 0.92) {
      reticleX = imageWidth * 0.92;
    }
    if (reticleY < 0) {
      reticleY = 0;
    }

    return Positioned(
      left: reticleX,
      top: reticleY,
      child: Row(
        children: [
          SvgPicture.asset(
            Assets.visceralFatAreaGraphReticle,
            width: _reticleSize,
            height: _reticleSize,
          ),
          const SizedBox(width: 8),
          Text(
            visceralFatArea.value.toStringPretty(),
            style: AppTextStyles.biomarkerVisceralFatAreaGraph,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  visceralFatArea.name,
                  style: AppTextStyles.biomarkerVisceralFatAreaGraph,
                ),
              ),
              Text(
                '${visceralFatArea.value.toStringPretty()}${visceralFatArea.unit != null ? ' ${visceralFatArea.unit}' : ''}',
                style: AppTextStyles.biomarkerVisceralFatAreaGraph,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(
              builder: (context, constraints) => Stack(
                children: [
                  SvgPicture.asset(
                    Assets.visceralFatAreaGraph,
                    width: constraints.maxWidth,
                    fit: BoxFit.cover,
                  ),
                  _buildReticle(constraints.maxWidth),
                ],
              ),
            ),
          ),
        ],
      );
}
