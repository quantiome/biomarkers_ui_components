import '../models/biomarker_data.dart';
import '../models/errors.dart';

abstract class BiomarkerValidator {
  /// Checks the given biomarkers for errors.
  ///
  /// All individual errors (that would prevent displaying the biomarker properly) can be accessed in
  /// the returned [BiomarkerValidationResult.processingErrors].
  ///
  /// This function will also check if the biomarkers are valid as a group (i.e. if the group can be displayed properly
  /// when passed to [BiomarkerCard]). If the returned [BiomarkerValidationResult.hasErrors] is false then the
  /// biomarkers can be displayed together.
  ///
  /// If [BiomarkerValidationResult.hasWarnings] is true then likely there are issues with the biomarkers (as a group), but
  /// they can still be displayed.
  static BiomarkerValidationResult validateBiomarkers(List<BiomarkerData> biomarkers) {
    final List<BiomarkerProcessingException> processingErrors = [];
    BiomarkersMismatchException? mismatchError;
    BiomarkersDuplicatesException? duplicatesError;
    BiomarkersDifferentNamesException? differentNamesWarning;

    List<dynamic> processedBiomarkers = biomarkers
        .map((biomarker) {
          try {
            return biomarker.convertToKnownType();
          } on BiomarkerProcessingException catch (e) {
            processingErrors.add(e);
            return null;
          }
        })
        .where((biomarker) => biomarker != null)
        .toList();

    if (processedBiomarkers.isNotEmpty) {
      final bool areAllOfSameType =
          !processedBiomarkers.any((biomarker) => biomarker.runtimeType != processedBiomarkers.first.runtimeType);
      if (!areAllOfSameType) {
        mismatchError = BiomarkersMismatchException(biomarkers: processedBiomarkers);
      }
    }

    final List<BiomarkerData> duplicates = [];
    for (int i = 0; i < biomarkers.length - 1; i++) {
      for (int j = i + 1; j < biomarkers.length; j++) {
        if (biomarkers[i] == biomarkers[j]) {
          duplicates.add(biomarkers[i]);
        }
      }
    }
    if (duplicates.isNotEmpty) {
      duplicatesError = BiomarkersDuplicatesException(biomarkers: duplicates);
    }

    final List<BiomarkerData> differentNames = [];
    for (int i = 0; i < biomarkers.length - 1; i++) {
      for (int j = i + 1; j < biomarkers.length; j++) {
        if (biomarkers[i].name != biomarkers[j].name) {
          differentNames.add(biomarkers[i]);
        }
      }
    }
    if (differentNames.isNotEmpty) {
      differentNamesWarning = BiomarkersDifferentNamesException(biomarkers: biomarkers);
    }

    return BiomarkerValidationResult(
      processingErrors: processingErrors,
      mismatchError: mismatchError,
      duplicatesWarning: duplicatesError,
      differentNamesWarning: differentNamesWarning,
    );
  }
}

/// See [BiomarkerValidator.validateBiomarkers].
class BiomarkerValidationResult {
  final List<BiomarkerProcessingException> processingErrors;
  final BiomarkersMismatchException? mismatchError;
  final BiomarkersDuplicatesException? duplicatesWarning;
  final BiomarkersDifferentNamesException? differentNamesWarning;

  /// Some of these biomarkers could not be parsed properly. They will not display
  /// properly (either individually or as a group).
  bool get hasIndividualErrors => processingErrors.isNotEmpty;

  /// These biomarkers cannot be displayed properly as a group (but if [hasIndividualErrors] is false then each
  /// of them can be displayed individually).
  bool get hasGroupErrors => mismatchError != null;

  bool get hasErrors => hasGroupErrors || hasIndividualErrors;

  /// Something might be wrong with these biomarkers.
  bool get hasWarnings => duplicatesWarning != null || differentNamesWarning != null;

  BiomarkerValidationResult({
    required this.processingErrors,
    required this.mismatchError,
    required this.duplicatesWarning,
    required this.differentNamesWarning,
  });
}
