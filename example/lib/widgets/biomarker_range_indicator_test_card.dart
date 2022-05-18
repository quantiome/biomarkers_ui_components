import 'package:flutter/material.dart';
import 'package:groqhealth_biomarkers/groqhealth_biomarkers.dart';

class BiomarkerRangeIndicatorTestCard extends StatelessWidget {
  const BiomarkerRangeIndicatorTestCard({Key? key}) : super(key: key);

  Widget _buildTitle(BuildContext context) => const Text(
        'CRR - Cholesterol risk ratio',
        style: TextStyle(fontSize: 16, color: Color(0xFF081629)),
      );

  Widget _buildDate(BuildContext context) => const Text(
        'Apr 2022',
        style: TextStyle(fontSize: 14, color: Color(0xFF6C7889)),
      );

  Widget _buildValue(BuildContext context) => const Text(
        '1.2',
        style: TextStyle(fontSize: 48, color: Color(0xFF081629)),
      );

  Widget _buildOptimalRange(BuildContext context) => const Text(
        'optimal range: 0-2',
        style: TextStyle(fontSize: 14, color: Color(0xFF6C7889)),
      );

  Widget _buildBiomarkerRangeIndicator(BuildContext context) => const BiomarkerRangeIndicator(
        maxValue: 4.5,
        minValue: 0,
        value: 0.5,
        textStyle: TextStyle(fontSize: 14, color: Color(0xFF6C7889)),
        maxOptimalValue: 2.9,
        minOptimalValue: 2,
        maxBorderlineValue: 4.2,
        minBorderlineValue: 1,
      );

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDate(context),
                  const SizedBox(height: 16),
                  _buildValue(context),
                  const SizedBox(height: 16),
                  _buildOptimalRange(context),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 40),
                child: SizedBox(
                  height: 220,
                  child: _buildBiomarkerRangeIndicator(context),
                ),
              ),
            ],
          ),
        ],
      );
}
