import 'package:flutter/material.dart';

import 'widgets/biomarker_range_indicator_test_card.dart';
import 'widgets/biomarker_trend_line_test_card.dart';

enum DisplayType {
  rangeIndicator,
  trendLine,
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
  DisplayType _displayType = DisplayType.rangeIndicator;

  void _onFloatingActionButtonTap() {
    final int selectedTypeIndex = DisplayType.values.indexOf(_displayType);
    int newTypeIndex = selectedTypeIndex + 1;
    if (newTypeIndex >= DisplayType.values.length) {
      newTypeIndex = 0;
    }

    setState(() => _displayType = DisplayType.values[newTypeIndex]);
  }

  Widget get _child {
    switch (_displayType) {
      case DisplayType.rangeIndicator:
        return const BiomarkerRangeIndicatorTestCard();
      case DisplayType.trendLine:
        return const BiomarkerTrendLineTestCard();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: _onFloatingActionButtonTap,
          child: Icon(Icons.swap_horiz),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: _child,
            ),
          ),
        ),
      );
}
