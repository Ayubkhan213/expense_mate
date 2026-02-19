import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  // ============================================
  // WEIGHT MODIFIERS
  // ============================================
  TextStyle get thin => copyWith(fontWeight: FontWeight.w100);
  TextStyle get extraLight => copyWith(fontWeight: FontWeight.w200);
  TextStyle get light => copyWith(fontWeight: FontWeight.w300);
  TextStyle get regular => copyWith(fontWeight: FontWeight.w400);
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);
  TextStyle get bold => copyWith(fontWeight: FontWeight.w700);
  TextStyle get extraBold => copyWith(fontWeight: FontWeight.w800);
  TextStyle get black => copyWith(fontWeight: FontWeight.w900);

  // ============================================
  // STYLE MODIFIERS
  // ============================================
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);
  TextStyle get overline => copyWith(decoration: TextDecoration.overline);

  // ============================================
  // COLOR METHODS
  // ============================================
  TextStyle withColor(Color color) => copyWith(color: color);

  TextStyle withOpacity(double opacity) =>
      copyWith(color: color?.withOpacity(opacity));

  // ============================================
  // SIZE MODIFIERS
  // ============================================
  TextStyle withSize(double size) => copyWith(fontSize: size);

  TextStyle scale(double factor) =>
      copyWith(fontSize: (fontSize ?? 14) * factor);

  // ============================================
  // LETTER SPACING
  // ============================================
  TextStyle withLetterSpacing(double spacing) =>
      copyWith(letterSpacing: spacing);

  // ============================================
  // LINE HEIGHT
  // ============================================
  TextStyle withHeight(double height) => copyWith(height: height);

  // ============================================
  // COMBINATION HELPERS
  // ============================================
  TextStyle get primaryStyle => this; // Will use theme primary color
  TextStyle get secondaryStyle => this; // Will use theme secondary color

  // For financial data
  TextStyle get positive => this; // Will use success color
  TextStyle get negative => this; // Will use error/danger color
}
