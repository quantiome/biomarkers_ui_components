import 'package:flutter/material.dart';
import 'package:groqhealth_biomarkers/src/widgets/biomarker_card/biomarker_card_fallback.dart';

import '../../models/biomarker_data.dart';
import '../../models/biomarker_number.dart';
import '../../models/biomarker_string.dart';
import 'biomarker_card_range_indicator.dart';
import 'biomarker_card_string.dart';
import 'biomarker_card_trend_line.dart';

/// This widget will try its best to display the given data (without erroring).
/// Some of the biomarkers may be silently discarded if they contain invalid data, and if there is a global mismatch
/// between the biomarkers then they will all be discarded, effectively displaying nothing.
class BiomarkerCard extends StatelessWidget {
  final List<dynamic> biomarkers;
  final String? note;

  BiomarkerCard({
    Key? key,
    required List<BiomarkerData> biomarkers,
    this.note,
  })  : biomarkers = _processBiomarkers(biomarkers),
        super(key: key);

  static List<dynamic> _processBiomarkers(List<BiomarkerData> biomarkers) {
    if (biomarkers.isEmpty) {
      return [];
    }

    List<dynamic> processedBiomarkers = biomarkers
        .map((biomarker) {
          try {
            return biomarker.convertToKnownType();
          } catch (e) {
            /// Erroneous biomarkers are discarded.
            return null;
          }
        })
        .where((biomarker) => biomarker != null)
        .toList();

    if (processedBiomarkers.isNotEmpty) {
      final bool areAllOfSameType = !processedBiomarkers.any(
        (biomarker) => biomarker.runtimeType != processedBiomarkers.first.runtimeType,
      );
      if (!areAllOfSameType) {
        /// We do not support displaying mismatching biomarkers.
        return [];
      }
    } else {
      /// All the biomarkers are invalid, display a fallback.
      final BiomarkerData newestBiomarker =
          biomarkers.reduce((previous, current) => previous.time.isBefore(current.time) ? current : previous);
      return [newestBiomarker];
    }

    return processedBiomarkers;
  }

  @override
  Widget build(BuildContext context) {
    if (biomarkers.isEmpty) {
      const SizedBox();
    } else if (biomarkers.first is BiomarkerNumber) {
      if (biomarkers.length == 1) {
        return BiomarkerCardRangeIndicator(
          biomarker: biomarkers.first as BiomarkerNumber,
          note: note,
        );
      } else {
        return BiomarkerCardTrendLine(
          biomarkers: biomarkers.cast<BiomarkerNumber>(),
          note: note,
        );
      }
    } else if (biomarkers.first is BiomarkerString) {
      return BiomarkerCardString(
        biomarker: biomarkers.first as BiomarkerString,
        note: note,
      );
    } else if (biomarkers.first is BiomarkerData) {
      return BiomarkerCardFallback(
        biomarker: biomarkers.first as BiomarkerData,
        note: note,
      );
    }

    return const SizedBox();
  }
}
