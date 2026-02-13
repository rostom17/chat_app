import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double defaultSize;
  static late Brightness platformBrightness;
  static late Orientation orientation;


  static bool get isDarkMode => platformBrightness == Brightness.dark;
  static bool get isLightMode => platformBrightness == Brightness.light;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    platformBrightness = _mediaQueryData.platformBrightness;
    orientation = _mediaQueryData.orientation;
  }
}

double getProportionateScreenHeight(double inputHeight) {
  double screenHeight = SizeConfig.screenHeight;
  return (inputHeight / 812.0) * screenHeight;
}

double getProportionateScreenWidth(double inputWidth) {
  double screenWidth = SizeConfig.screenWidth;
  return (inputWidth / 375.0) * screenWidth;
}

extension SizeExtension on num {
  double get h => getProportionateScreenHeight(toDouble());
  double get w => getProportionateScreenWidth(toDouble());
  double get sp => getProportionateScreenWidth(toDouble());
}
