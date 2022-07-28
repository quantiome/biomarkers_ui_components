import 'package:flutter/widgets.dart';

@immutable
abstract class Assets {
  static const String _packagePath = 'packages/groqhealth_biomarkers/';
  static const String _imagesFolder = 'resources/images/';
  static const String _assetsPath = '$_packagePath$_imagesFolder';

  static const String visceralFatAreaGraph = '${_assetsPath}visceral_fat_area_graph.svg';
  static const String visceralFatAreaGraphReticle = '${_assetsPath}visceral_fat_area_graph_reticle.svg';
}
