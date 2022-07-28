import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/biomarker_data.dart';
import '../utils/colors.dart';
import '../utils/extensions.dart';
import '../utils/text_styles.dart';

/// Meant to display the 3 biomarkers "Weight", "Skeletal Muscle Mass" and "Body Fat Mass" with a special UI.
/// In reality it can display the special UI with any [BiomarkerData], it's the caller responsibility to feed the
/// right biomarker type.
class BiomarkersMuscleFatAnalysis extends StatelessWidget {
  final BiomarkerData? weight;
  final BiomarkerData? skeletalMuscleMass;
  final BiomarkerData? bodyFatMass;

  const BiomarkersMuscleFatAnalysis({
    Key? key,
    required this.weight,
    required this.skeletalMuscleMass,
    required this.bodyFatMass,
  }) : super(key: key);

  Widget _buildBioMarker({
    required BuildContext context,
    required BiomarkerData bioMarker,
  }) {
    double barWidthRatio = 0;
    final double? minValue = bioMarker.minValue;
    final double? maxValue = bioMarker.maxValue;
    if (bioMarker.value is num && minValue != maxValue && maxValue != null && minValue != null) {
      barWidthRatio = (bioMarker.value as num).toDouble().normalize(minValue, maxValue);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          bioMarker.name,
          style: AppTextStyles.biomarkersMuscleFatAnalysisText,
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double barLength = barWidthRatio * constraints.maxWidth;
                  return Container(
                    height: 15,
                    width: barLength,
                    decoration: BoxDecoration(
                      color: AppColors.purple500,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
            if (barWidthRatio != 0) const SizedBox(width: 6),
            Text(
              bioMarker.value is num ? (bioMarker.value as num).toStringPretty() : bioMarker.value?.toString() ?? '',
              style: AppTextStyles.biomarkersMuscleFatAnalysisText,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (weight != null)
            _buildBioMarker(
              context: context,
              bioMarker: weight!,
            ),
          if (skeletalMuscleMass != null)
            _buildBioMarker(
              context: context,
              bioMarker: skeletalMuscleMass!,
            ),
          if (bodyFatMass != null)
            _buildBioMarker(
              context: context,
              bioMarker: bodyFatMass!,
            ),
        ].interlacedWith(const SizedBox(height: 16)),
      );
}
