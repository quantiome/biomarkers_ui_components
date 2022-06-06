import 'package:flutter/material.dart';

import '../../models/biomarker_number.dart';
import '../../utils/text_styles.dart';
import '../biomarker_trend_line.dart';

class BiomarkerCardTrendLine extends StatelessWidget {
  final List<BiomarkerNumber> biomarkers;
  final String? note;

  String get _name => biomarkers.isEmpty ? '' : biomarkers.first.name;

  bool get _hasNote => note != null && note!.isNotEmpty;

  const BiomarkerCardTrendLine({
    Key? key,
    required this.biomarkers,
    required this.note,
  }) : super(key: key);

  Widget _buildTitleText() => Text(
        _name,
        style: AppTextStyles.biomarkerName,
      );

  Widget _buildNoteText() => Text(
        note ?? '',
        style: AppTextStyles.biomarkerNote,
      );

  Widget _buildBiomarkerTrendLine() => BiomarkerTrendLine(
        biomarkers: biomarkers,
        valueTextStyle: AppTextStyles.biomarkerCardTrendLineValue,
        dateTextStyle: AppTextStyles.biomarkerDate,
        hiddenPointsCountTextStyle: AppTextStyles.biomarkerTrendLineHiddenPointsCount,
        maxPointsToDisplayCount: 3,
      );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleText(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _buildBiomarkerTrendLine(),
          ),
          if (_hasNote) ...[
            const SizedBox(height: 20),
            _buildNoteText(),
          ]
        ],
      );
}
