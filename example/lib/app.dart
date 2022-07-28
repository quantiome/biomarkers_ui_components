import 'package:flutter/material.dart';
import 'package:groqhealth_biomarkers/groqhealth_biomarkers.dart';

import '../utils/extensions.dart';

enum DisplayType {
  muscleFatAnalysis,
  visceralFatArea,
  leanBodyMass,
  rangeIndicator,
  rangeIndicator2,
  trendLine,
  string,
  stringWithNumbers,
  prefixedNumber,
  erroneousSingleNumber,
  erroneousSingleNumber2,
  erroneousMultipleNumbers,
  erroneousString,
  erroneousUnknownType,
  erroneousFallback,
  erroneousDuplicates,
  erroneousDifferentNames,
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'groqhealth_biomarkers example',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const _MyHomePage(),
      );
}

class _MyHomePage extends StatefulWidget {
  const _MyHomePage({Key? key}) : super(key: key);

  @override
  State<_MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  DisplayType _displayType = DisplayType.values.first;
  List<String> errorMessages = [];

  @override
  void initState() {
    errorMessages = _processErrors(_biomarkers);
    super.initState();
  }

  void _onFloatingActionButtonTap() {
    final int selectedTypeIndex = DisplayType.values.indexOf(_displayType);
    int newTypeIndex = selectedTypeIndex + 1;
    if (newTypeIndex >= DisplayType.values.length) {
      newTypeIndex = 0;
    }

    if (mounted) {
      setState(() {
        _displayType = DisplayType.values[newTypeIndex];
        errorMessages = _processErrors(_biomarkers);
      });
    }
  }

  static List<String> _processErrors(List<BiomarkerData> biomarkers) {
    final BiomarkerValidationResult validationResult = BiomarkerValidator.validateBiomarkers(biomarkers);

    final List<String> errorMessages = validationResult.processingErrors.map((error) => error.toString()).toList();
    if (validationResult.mismatchError != null) {
      errorMessages.add(validationResult.mismatchError.toString());
    }
    if (validationResult.duplicatesWarning != null) {
      errorMessages.add(validationResult.duplicatesWarning.toString());
    }
    if (validationResult.differentNamesWarning != null) {
      errorMessages.add(validationResult.differentNamesWarning.toString());
    }

    return errorMessages;
  }

  BiomarkerData _generateTrendLineBiomarker(
    double value,
    DateTime time, {
    double? maxValue,
    double? minValue,
    double? maxOptimalValue,
    double? minOptimalValue,
    double? maxBorderlineValue,
    double? minBorderlineValue,
    String? name,
    String? unit,
  }) =>
      BiomarkerData(
        value: value,
        time: time,
        maxValue: maxValue ?? 4.5,
        minValue: minValue ?? 0,
        maxOptimalValue: maxOptimalValue ?? maxOptimalValue ?? 2.9,
        minOptimalValue: minOptimalValue ?? 2,
        maxBorderlineValue: maxBorderlineValue ?? 4.2,
        minBorderlineValue: minBorderlineValue ?? 1,
        name: name ?? 'CRR - Cholesterol risk ratio',
        unit: unit ?? '%',
      );

  List<BiomarkerData> get _biomarkers {
    switch (_displayType) {
      case DisplayType.muscleFatAnalysis:
        return [
          BiomarkerData(
            value: 80,
            maxValue: 300,
            minValue: 40,
            maxOptimalValue: 100,
            minOptimalValue: 50,
            name: 'Weight',
            time: DateTime(2022, 04),
            unit: 'lbs',
          ),
          BiomarkerData(
            value: 33,
            maxValue: 100,
            minValue: 20,
            maxOptimalValue: 80,
            minOptimalValue: 30,
            name: 'Skeletal Muscle Mass',
            time: DateTime(2022, 04),
            unit: 'lbs',
          ),
          BiomarkerData(
            value: 21,
            maxValue: 200,
            minValue: 0,
            maxOptimalValue: 40,
            minOptimalValue: 0,
            name: 'Body Fat Mass',
            time: DateTime(2022, 04),
            unit: 'lbs',
          ),
        ];
      case DisplayType.visceralFatArea:
        return [
          BiomarkerData(
            value: 100,
            maxValue: 200,
            minValue: 0,
            maxOptimalValue: 100,
            minOptimalValue: 0,
            name: 'Visceral Fat Area',
            time: DateTime(2022, 04),
            unit: 'cm²',
          ),
        ];
      case DisplayType.leanBodyMass:
        return [
          BiomarkerData(
            value: 10,
            maxValue: 200,
            minValue: 0,
            maxOptimalValue: 70,
            minOptimalValue: 5,
            name: 'Lean Body Mass',
            time: DateTime(2022, 04),
            unit: 'lbs',
          ),
        ];
      case DisplayType.rangeIndicator:
        return [
          BiomarkerData(
            value: 6,
            maxValue: 4.5,
            minValue: 0,
            maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
            unit: '%',
          ),
        ];
      case DisplayType.rangeIndicator2:
        return [
          BiomarkerData(
            // value: 2.6, // Optimal
            // value: 2.4, // BorderlineLow
            value: 1.6,
            // BadLow
            // value: 1.0, // VeryBadLow
            // value: 3.2, // BorderlineHigh
            // value: 3.9, // BadHigh
            // value: 4.5, // VeryBadHigh
            maxValue: 4.5,
            minValue: 0,
            maxOptimalValue: 3,
            minOptimalValue: 2.5,
            maxBorderlineValue: 3.6,
            minBorderlineValue: 1.8,
            maxBadValue: 4,
            minBadValue: 1.2,
            maxVeryBadValue: 4.5,
            minVeryBadValue: 0,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
            unit: '%',
          ),
        ];
      case DisplayType.trendLine:
        return [
          _generateTrendLineBiomarker(0.6, DateTime(2022, 02, 03)),
          _generateTrendLineBiomarker(2.4, DateTime(2022, 04, 25)),
          _generateTrendLineBiomarker(1, DateTime(2021, 10, 12)),
          _generateTrendLineBiomarker(1.6, DateTime(2021, 04, 25)),
          _generateTrendLineBiomarker(0.6, DateTime(2021, 01, 30)),
        ];
      case DisplayType.string:
        return [
          BiomarkerData(
            value: 'Negative',
            name: 'Covid test',
            time: DateTime(2022, 04),
          ),
        ];
      case DisplayType.stringWithNumbers:
        return [
          BiomarkerData(
            value: '2.8|2.9',
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 03),
            unit: '%',
            minOptimalValue: 4,
          ),
        ];
      case DisplayType.prefixedNumber:
        return [
          BiomarkerData(
            value: '>0.1',
            maxValue: 4.5,
            minValue: 0,
            maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
            // unit: '%',
          ),
        ];
      case DisplayType.erroneousSingleNumber:
        return [
          BiomarkerData(
            value: 2,
            maxValue: 4.5,
            minValue: 0,
            // maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
            // unit: '%',
          ),
        ];
      case DisplayType.erroneousSingleNumber2:
        return [
          BiomarkerData(
            value: 2,
            maxValue: 4.5,
            minValue: 0,
            maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 3.2,
            minBorderlineValue: 1.5,
            // Missing maxBadValue and minBadValue
            maxVeryBadValue: 4.5,
            minVeryBadValue: 0.5,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
            // unit: '%',
          ),
        ];
      case DisplayType.erroneousMultipleNumbers:
        return [
          _generateTrendLineBiomarker(2, DateTime(2022, 04)),
          _generateTrendLineBiomarker(2.4, DateTime(2022, 01)),
          _generateTrendLineBiomarker(2.5, DateTime(2021, 8)),
          BiomarkerData(
            value: 2.7,
            // maxValue: 4.5,
            // minValue: 0,
            maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2021, 11),
            // unit: '%',
          ),
          BiomarkerData(
            value: 2.4,
            maxValue: 0,
            // Max and min inverted.
            minValue: 4.5,
            maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2021, 04),
            // unit: '%',
          ),
        ];
      case DisplayType.erroneousString:
        return [
          BiomarkerData(
            value: '',
            name: 'Covid test result',
            time: DateTime(2022, 04),
          ),
        ];
      case DisplayType.erroneousUnknownType:
        return [
          BiomarkerData(
            value: DateTime.now(),
            name: 'Random invalid value.',
            time: DateTime(2022, 04),
          ),
        ];
      case DisplayType.erroneousFallback:
        return [
          BiomarkerData(
            value: 1.5,
            maxValue: 4.5,
            minValue: 0,
            // maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
          ),
          BiomarkerData(
            value: 2.5,
            maxValue: 4.5,
            minValue: 0,
            // maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
          ),
          BiomarkerData(
            value: 3.5,
            maxValue: 4.5,
            minValue: 0,
            // maxOptimalValue: 2.9,
            minOptimalValue: 2,
            maxBorderlineValue: 4.2,
            minBorderlineValue: 1,
            name: 'CRR - Cholesterol risk ratio',
            time: DateTime(2022, 04),
          ),
        ];
      case DisplayType.erroneousDuplicates:
        return [
          _generateTrendLineBiomarker(0.6, DateTime(2022, 02, 03)),
          _generateTrendLineBiomarker(0.6, DateTime(2022, 02, 03)),
          _generateTrendLineBiomarker(1.6, DateTime(2021, 10, 12)),
          _generateTrendLineBiomarker(1, DateTime(2021, 04, 25)),
          _generateTrendLineBiomarker(0.6, DateTime(2021, 01, 30)),
        ];
      case DisplayType.erroneousDifferentNames:
        return [
          _generateTrendLineBiomarker(0.6, DateTime(2022, 02, 03)),
          _generateTrendLineBiomarker(2.4, DateTime(2022, 04, 25), name: 'Other name'),
          _generateTrendLineBiomarker(1.6, DateTime(2021, 10, 12)),
          _generateTrendLineBiomarker(1, DateTime(2021, 04, 25), name: 'Yet another name'),
          _generateTrendLineBiomarker(0.6, DateTime(2021, 01, 30)),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    late final Widget child;
    if (_displayType == DisplayType.muscleFatAnalysis) {
      child = Container(
        color: Colors.black12,
        padding: const EdgeInsets.all(8),
        child: Align(
          alignment: Alignment.topLeft,
          child: BiomarkersMuscleFatAnalysis(
            weight: _biomarkers[0],
            skeletalMuscleMass: _biomarkers[1],
            bodyFatMass: _biomarkers[2],
          ),
        ),
      );
    } else if (_displayType == DisplayType.visceralFatArea) {
      child = Container(
        color: Colors.black12,
        padding: const EdgeInsets.all(8),
        child: BiomarkerVisceralFatArea(
          visceralFatArea: _biomarkers.first.convertToKnownType() as BiomarkerNumber,
          userAge: 42,
        ),
      );
    } else if (_displayType == DisplayType.leanBodyMass) {
      child = Container(
        color: Colors.black12,
        padding: const EdgeInsets.all(8),
        child: BiomarkerLeanBodyMass(
          leanBodyMass: _biomarkers.first.convertToKnownType() as BiomarkerNumber,
        ),
      );
    } else {
      child = BiomarkerCard(
        biomarkers: _biomarkers,
        note: 'You’re on a roll. Keep doing what you’re doing!',
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: _onFloatingActionButtonTap,
        child: Icon(Icons.swap_horiz),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_displayType.toString()),
                  SizedBox(height: 48),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 400),
                    child: child,
                  ),
                  if (errorMessages.isNotEmpty) ...[
                    const SizedBox(height: 36),
                    const Text('Some of the data is invalid!'),
                    const SizedBox(height: 26),
                  ],
                  ...errorMessages
                      .map<Widget>(
                        (message) => Text(
                          message,
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                          ),
                        ),
                      )
                      .toList()
                      .interlacedWith(const SizedBox(height: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
