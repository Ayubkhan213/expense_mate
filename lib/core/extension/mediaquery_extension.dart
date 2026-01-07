import 'package:flutter/material.dart';

extension MediaQueryExt on BuildContext {
  /// Screen size
  Size get screenSize => MediaQuery.of(this).size;

  double get width => screenSize.width;
  double get height => screenSize.height;

  /// Orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Padding (SafeArea)
  EdgeInsets get padding => MediaQuery.of(this).padding;

  double get topPadding => padding.top;
  double get bottomPadding => padding.bottom;

  /// Keyboard
  double get keyboardHeight => MediaQuery.of(this).viewInsets.bottom;
  bool get isKeyboardOpen => keyboardHeight > 0;

  /// Device type helpers
  bool get isMobile => width < 600;
  bool get isTablet => width >= 600 && width < 1024;
  bool get isDesktop => width >= 1024;

  /// Responsive width/height (percentage based)
  double wp(double percent) => width * (percent / 100);
  double hp(double percent) => height * (percent / 100);
}
