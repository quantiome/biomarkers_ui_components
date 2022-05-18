import 'package:flutter/material.dart';
import 'package:groqhealth_biomarkers/groqhealth_biomarkers.dart';

class BiomarkerTrendLineTestCard extends StatelessWidget {
  const BiomarkerTrendLineTestCard({Key? key}) : super(key: key);

  Widget _buildTitle(BuildContext context) => const Text(
        'CRR - Cholesterol risk ratio',
        style: TextStyle(fontSize: 16, color: Color(0xFF081629)),
      );

  Widget _buildBiomarkerTrendLine(BuildContext context) => BiomarkerTrendLine(
        points: [
          BiomarkerTrendLinePoint(value: 1.2, time: DateTime(2022, 02, 03)),
          BiomarkerTrendLinePoint(value: 2.4, time: DateTime(2022, 04, 25)),
          BiomarkerTrendLinePoint(value: 1.6, time: DateTime(2021, 10, 12)),
          BiomarkerTrendLinePoint(value: 1, time: DateTime(2021, 04, 25)),
          BiomarkerTrendLinePoint(value: 0.6, time: DateTime(2021, 01, 30)),
        ],
        maxPointsToDisplayCount: 3,
        valueTextStyle: const TextStyle(fontSize: 20, color: Color(0xFF081629)),
        dateTextStyle: const TextStyle(fontSize: 14, color: Color(0xFF6C7889)),
        hiddenPointsCountTextStyle: const TextStyle(fontSize: 16, color: Color(0xFF3F4650)),
      );

  Widget _buildInsight(BuildContext context) => const Text(
        'You’re on a roll. Keep doing what you’re doing!',
        style: TextStyle(fontSize: 14, color: Color(0xFF6C7889)),
      );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: _buildBiomarkerTrendLine(context),
          ),
          const SizedBox(height: 20),
          _buildInsight(context),
        ],
      );
}
