import 'package:flutter/material.dart';

import '../constants.dart';

/// Centralized text-style helpers built on top of the custom fonts
/// registered in pubspec.yaml (Klavika for headings, Frutiger for body).
class CustomFont {
  CustomFont._();

  static TextStyle heading({double size = 22, Color? color}) => TextStyle(
        fontFamily: AppFonts.klavika,
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
      );

  static TextStyle subheading({double size = 16, Color? color}) => TextStyle(
        fontFamily: AppFonts.klavika,
        fontSize: size,
        fontWeight: FontWeight.w600,
        color: color,
      );

  static TextStyle body({double size = 14, Color? color}) => TextStyle(
        fontFamily: AppFonts.frutiger,
        fontSize: size,
        fontWeight: FontWeight.normal,
        color: color,
      );

  static TextStyle caption({double size = 12, Color? color}) => TextStyle(
        fontFamily: AppFonts.frutiger,
        fontSize: size,
        color: color ?? Colors.grey,
      );
}
