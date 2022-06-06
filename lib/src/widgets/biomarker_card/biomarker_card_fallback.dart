import 'package:flutter/material.dart';
import 'package:groqhealth_biomarkers/groqhealth_biomarkers.dart';

import '../../utils/extensions.dart';
import '../../utils/text_styles.dart';

class BiomarkerCardFallback extends StatelessWidget {
  final BiomarkerData biomarker;
  final String? note;

  bool get _hasNote => note != null && note!.isNotEmpty;

  const BiomarkerCardFallback({
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
          text: biomarker.value.toString(),
          style: AppTextStyles.biomarkerCardStringValue,
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
      text = '> ${biomarker.minOptimalValue!.toStringPretty()}';
    } else if (biomarker.minOptimalValue == null) {
      text = '< ${biomarker.maxOptimalValue!.toStringPretty()}';
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

  Widget _buildNoteText() => Text(
        note ?? '',
        style: AppTextStyles.biomarkerNote,
      );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(),
          const SizedBox(height: 8),
          _buildDateText(),
          const SizedBox(height: 16),
          _buildValueText(),
          if (biomarker.maxOptimalValue != null || biomarker.minOptimalValue != null) ...[
            const SizedBox(height: 16),
            _buildOptimalRangeText(),
          ],
          if (_hasNote) ...[
            const SizedBox(height: 8),
            _buildNoteText(),
          ]
        ],
      );
}
