import 'package:flutter/material.dart';

import '../../models/biomarker_number.dart';
import '../../utils/colors.dart';
import '../../utils/extensions.dart';
import '../../utils/text_styles.dart';
import '../range_indicator.dart';

class BiomarkerCardRangeIndicator extends StatelessWidget {
  final BiomarkerNumber biomarker;
  final String? note;

  bool get _hasNote => note != null && note!.isNotEmpty;

  const BiomarkerCardRangeIndicator({
    Key? key,
    required this.biomarker,
    required this.note,
  }) : super(key: key);

  Widget _buildTitleText() => Text(
        biomarker.name,
        style: AppTextStyles.biomarkerName,
      );

  Widget _buildDateText() => Text(
        biomarker.time.toAbrMonthAndYearString(),
        style: AppTextStyles.biomarkerDate,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );

  Widget _buildValueText() => RichText(
        text: TextSpan(
          text: '${biomarker.prefix ?? ''}${biomarker.value.toStringPretty()}',
          style: AppTextStyles.biomarkerCardRangeIndicatorValue,
          children: <TextSpan>[
            if (biomarker.unit != null)
              TextSpan(
                text: biomarker.unit,
                style: AppTextStyles.biomarkerUnit,
              ),
          ],
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );

  Widget _buildOptimalRangeText() {
    late final String text;
    if (biomarker.maxOptimalValue == null && biomarker.minOptimalValue == null) {
      text = '--';
    } else if (biomarker.maxOptimalValue == null) {
      text = 'Over ${biomarker.minOptimalValue!.toStringPretty()}';
    } else if (biomarker.minOptimalValue == null) {
      text = 'Under ${biomarker.maxOptimalValue!.toStringPretty()}';
    } else {
      text = '${biomarker.minOptimalValue!.toStringPretty()} - ${biomarker.maxOptimalValue!.toStringPretty()}';
    }

    return Text(
      'optimal range: $text',
      style: AppTextStyles.biomarkerOptimalRange,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
  }

  Widget _buildRangeDot() => Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: biomarker.range.color,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              biomarker.range.humanReadableName,
              style: AppTextStyles.biomarkerOptimalRange,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      );

  Widget _buildNoteText() => Text(
        note ?? '',
        style: AppTextStyles.biomarkerNote,
      );

  Widget _buildBiomarkerRangeIndicator() => RangeIndicator(
        value: biomarker.value.clampToDouble(biomarker.minValue!, biomarker.maxValue!),
        maxValue: biomarker.maxValue!,
        minValue: biomarker.minValue!,
        maxOptimalValue: biomarker.maxOptimalValue,
        minOptimalValue: biomarker.minOptimalValue,
        maxBorderlineValue: biomarker.maxBorderlineValue,
        minBorderlineValue: biomarker.minBorderlineValue,
        maxBadValue: biomarker.maxBadValue,
        minBadValue: biomarker.minBadValue,
        maxVeryBadValue: biomarker.maxVeryBadValue,
        minVeryBadValue: biomarker.minVeryBadValue,
        textStyle: AppTextStyles.biomarkerRangeIndicatorMinMaxValues,
        barDefaultColor: AppColors.biomarkerDefault,
        barOptimalColor: AppColors.biomarkerOptimal,
        barBorderlineHighColor: AppColors.biomarkerBorderlineHigh,
        barBorderlineLowColor: AppColors.biomarkerBorderlineLow,
        barBadHighColor: AppColors.biomarkerBadHigh,
        barBadLowColor: AppColors.biomarkerBadLow,
        barVeryBadHighColor: AppColors.biomarkerVeryBadHigh,
        barVeryBadLowColor: AppColors.biomarkerVeryBadLow,
        cursorLineColor: AppColors.grey700,
        cursorTriangleColor: AppColors.grey700,
        coloredBarWidth: 46,
      );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDateText(),
                    const SizedBox(height: 16),
                    _buildValueText(),
                    const SizedBox(height: 16),
                    _buildOptimalRangeText(),
                    const SizedBox(height: 16),
                    if (biomarker.range != BiomarkerNumberRange.unknown) _buildRangeDot(),
                  ],
                ),
              ),
              if (biomarker.maxValue != null && biomarker.minValue != null) ...[
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 40),
                  child: SizedBox(
                    height: 220,
                    child: _buildBiomarkerRangeIndicator(),
                  ),
                ),
              ]
            ],
          ),
          if (_hasNote) ...[
            const SizedBox(height: 8),
            _buildNoteText(),
          ]
        ],
      );
}
