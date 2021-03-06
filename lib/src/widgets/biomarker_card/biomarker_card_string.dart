import 'package:flutter/material.dart';

import '../../models/biomarker_string.dart';
import '../../utils/extensions.dart';
import '../../utils/text_styles.dart';

class BiomarkerCardString extends StatelessWidget {
  final BiomarkerString biomarker;
  final String? note;

  bool get _hasNote => note != null && note!.isNotEmpty;

  const BiomarkerCardString({
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
          text: biomarker.value,
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
    if (!biomarker.hasOptimalRange) {
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
          if (biomarker.hasOptimalRange) ...[
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
