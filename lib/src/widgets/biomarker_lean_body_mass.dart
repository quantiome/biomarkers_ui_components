import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/biomarker_number.dart';
import '../utils/extensions.dart';
import '../utils/text_styles.dart';

/// Meant to display a biomarker of type Lean Body Mass with a special UI.
/// In reality it can display the special UI with any [BiomarkerNumber], it's the caller responsibility to feed the
/// right biomarker type.
class BiomarkerLeanBodyMass extends StatelessWidget {
  final BiomarkerNumber leanBodyMass;

  const BiomarkerLeanBodyMass({
    Key? key,
    required this.leanBodyMass,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  leanBodyMass.name,
                  style: AppTextStyles.biomarkerLeanBodyMassTitle,
                ),
              ),
              Text(
                '${leanBodyMass.value.toStringPretty()}${leanBodyMass.unit != null ? ' ${leanBodyMass.unit}' : ''}',
                style: AppTextStyles.biomarkerLeanBodyMassTitle,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Lean Body Mass (LBM) = Total Weight – Fat Mass',
            style: AppTextStyles.biomarkerLeanBodyMassText,
          ),
        ],
      );
}
