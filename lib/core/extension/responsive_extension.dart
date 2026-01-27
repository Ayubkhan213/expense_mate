// lib/core/extensions/responsive_extension.dart

import 'package:flutter/material.dart';

enum DeviceType { mobile, tablet }

class ResponsiveConfig {
  static double _designWidth = 440;
  static double _designHeight = 956;

  static double _screenWidth = 440;
  static double _screenHeight = 956;

  static double _pixelRatio = 1.0;
  static double _statusBarHeight = 0;
  static double _bottomBarHeight = 0;
  static double _textScaleFactor = 1.0;

  static bool _isInitialized = false;
  static DeviceType _deviceType = DeviceType.mobile;

  /// Call this once (usually in first screen or MaterialApp builder)
  static void init(
    BuildContext context, {
    double designWidth = 440,
    double designHeight = 956,
  }) {
    final mediaQuery = MediaQuery.of(context);

    _screenWidth = mediaQuery.size.width;
    _screenHeight = mediaQuery.size.height;

    _deviceType = _screenWidth <= 600 ? DeviceType.mobile : DeviceType.tablet;

    _designWidth = _deviceType == DeviceType.tablet ? 768 : designWidth;
    _designHeight = _deviceType == DeviceType.tablet ? 1024 : designHeight;

    _pixelRatio = mediaQuery.devicePixelRatio;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _textScaleFactor = mediaQuery.textScaleFactor;

    _isInitialized = true;
  }

  // ===============================
  // 🔹 DEVICE INFO
  // ===============================
  static bool get isTablet => _deviceType == DeviceType.tablet;
  static bool get isMobile => _deviceType == DeviceType.mobile;
  static bool get isInitialized => _isInitialized;

  // ===============================
  // 🔹 SCREEN INFO
  // ===============================
  static double get screenWidth => _screenWidth;
  static double get screenHeight => _screenHeight;
  static double get statusBarHeight => _statusBarHeight;
  static double get bottomBarHeight => _bottomBarHeight;
  static double get pixelRatio => _pixelRatio;
  static double get textScaleFactor => _textScaleFactor;

  // ===============================
  // 🔹 SCALE FACTORS
  // ===============================
  static double get scaleWidth => _screenWidth / _designWidth;
  static double get scaleHeight => _screenHeight / _designHeight;
  static double get scaleText => scaleWidth;

  // ===============================
  // 🔥 PERCENTAGE HELPERS
  // ===============================

  /// % of screen width
  static double percentWidth(num percent) => _screenWidth * (percent / 100);

  /// % of screen height
  static double percentHeight(num percent) => _screenHeight * (percent / 100);

  /// % of shorter side (great for square UI)
  static double percentShortest(num percent) =>
      (_screenWidth < _screenHeight ? _screenWidth : _screenHeight) *
      (percent / 100);
}

extension ResponsiveExtension on num {
  /// Width scale - use for horizontal sizing
  double get w => this * ResponsiveConfig.scaleWidth;

  /// Height scale - use for vertical sizing
  double get h => this * ResponsiveConfig.scaleHeight;

  /// Font size scale - use for text (capped for tablets)
  double get sp {
    double scale = ResponsiveConfig.scaleText;
    // Cap the scaling at 1.3x for tablets to prevent text from being too large
    if (ResponsiveConfig.isTablet && scale > 1.3) scale = 1.3;
    return this * scale;
  }

  /// Radius scale - use for border radius
  double get r => this * ResponsiveConfig.scaleWidth;

  /// Scale based on the smaller dimension (responsive for both orientations)
  double get sw =>
      this *
      (ResponsiveConfig.scaleWidth < ResponsiveConfig.scaleHeight
          ? ResponsiveConfig.scaleWidth
          : ResponsiveConfig.scaleHeight);

  /// Width scale with max cap (useful for preventing elements from being too large on tablets)
  double get wMax =>
      this *
      (ResponsiveConfig.scaleWidth > 1.5 ? 1.5 : ResponsiveConfig.scaleWidth);

  /// Height scale with max cap
  double get hMax =>
      this *
      (ResponsiveConfig.scaleHeight > 1.5 ? 1.5 : ResponsiveConfig.scaleHeight);

  // ===============================
  // 🔥 PERCENTAGE BASED SIZES
  // ===============================

  /// Percentage of screen width
  /// Example: 20.pw → 20% of screen width
  double get pw => ResponsiveConfig.screenWidth * (this / 100);

  /// Percentage of screen height
  /// Example: 30.ph → 30% of screen height
  double get ph => ResponsiveConfig.screenHeight * (this / 100);
}

extension ResponsiveContext on BuildContext {
  /// Screen width
  double get width => MediaQuery.of(this).size.width;

  /// Screen height
  double get height => MediaQuery.of(this).size.height;

  bool get isTablet => MediaQuery.of(this).size.shortestSide >= 600;

  bool get isMobile => MediaQuery.of(this).size.shortestSide < 600;

  /// Status bar height
  double get statusBarHeight => MediaQuery.of(this).padding.top;

  /// Bottom bar height
  double get bottomBarHeight => MediaQuery.of(this).padding.bottom;

  /// Is landscape orientation
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Is portrait orientation
  bool get isPortrait =>
      MediaQuery.of(this).orientation == Orientation.portrait;

  /// Device pixel ratio
  double get pixelRatio => MediaQuery.of(this).devicePixelRatio;

  /// Initialize responsive config with app's design dimensions
  void initResponsive() {
    ResponsiveConfig.init(this, designWidth: 440, designHeight: 956);
  }
}

extension ResponsiveWidget on Widget {
  /// Add responsive padding
  Widget paddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value.w), child: this);

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal.w,
          vertical: vertical.h,
        ),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left.w,
      top: top.h,
      right: right.w,
      bottom: bottom.h,
    ),
    child: this,
  );
}

extension SpacingExtension on num {
  /// SizedBox height
  SizedBox get sh => SizedBox(height: toDouble());

  /// SizedBox width
  SizedBox get sW => SizedBox(width: toDouble());
}

extension ResponsiveAlignment on Widget {
  /// Center
  Widget alignCenter() => Align(alignment: Alignment.center, child: this);

  /// Top
  Widget alignTop() => Align(alignment: Alignment.topCenter, child: this);

  /// Bottom
  Widget alignBottom() => Align(alignment: Alignment.bottomCenter, child: this);

  /// Left
  Widget alignLeft() => Align(alignment: Alignment.centerLeft, child: this);

  /// Right
  Widget alignRight() => Align(alignment: Alignment.centerRight, child: this);

  /// Custom alignment
  Widget align(Alignment alignment) => Align(alignment: alignment, child: this);
}

extension ResponsiveTap on Widget {
  Widget tap(
    VoidCallback onTap, {
    HitTestBehavior behavior = HitTestBehavior.opaque,
  }) => GestureDetector(behavior: behavior, onTap: onTap, child: this);
}

extension StringCasingExtension on String {
  /// Makes first letter uppercase, keeps rest as-is
  String capitalizeFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Makes first letter uppercase, rest lowercase
  String capitalizeFirstLowerRest() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1).toLowerCase();
  }
}
