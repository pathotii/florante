import 'package:flutter/material.dart';

class TColor {
  static Color get primaryColor1 => const Color(0xffffcc80);
  static Color get primaryColor2 => const Color.fromARGB(255, 240, 140, 41);

  static Color get secondaryColor1 => const Color(0xffB5C99A);
  static Color get secondaryColor2 => const Color(0xff97A97C);

  // Define orange colors
  static Color get orangeLight => const Color(0xffffcc80); // Light orange
  static Color get orangeDark => const Color(0xffff5722); // Dark orange

  static List<Color> get primaryG => [primaryColor2, primaryColor1];
  static List<Color> get secondaryG => [secondaryColor2, secondaryColor1];

  // Add a gradient for orange
  static List<Color> get orangeGradient => [orangeLight, orangeDark];

  static Color get black => const Color(0xff1D1617);
  static Color get gray => const Color(0xff786F72);
  static Color get white => Colors.white;
  static Color get lightGray => const Color(0xffF7F8F8);
}
