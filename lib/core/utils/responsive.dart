import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Design reference: 375 x 812 (iPhone X / common mobile)
/// Use this to scale layout and text across small to large phones and tablets.
class Responsive {
  Responsive._();

  static const double _designWidth = 375.0;
  static const double _designHeight = 812.0;

  /// Breakpoints for responsive layouts (width in logical pixels)
  static const double breakpointMobile = 360;
  static const double breakpointMobileLarge = 400;
  static const double breakpointTablet = 600;
  static const double breakpointDesktop = 900;

  static MediaQueryData _mediaQuery(BuildContext context) =>
      MediaQuery.of(context);

  /// Screen width
  static double width(BuildContext context) => _mediaQuery(context).size.width;

  /// Screen height
  static double height(BuildContext context) =>
      _mediaQuery(context).size.height;

  /// Width scale factor (relative to design width 375)
  static double widthScale(BuildContext context) {
    final w = width(context);
    return (w / _designWidth).clamp(0.85, 1.35);
  }

  /// Height scale factor (relative to design height 812)
  static double heightScale(BuildContext context) {
    final h = height(context);
    return (h / _designHeight).clamp(0.85, 1.35);
  }

  /// Scale a value by width (good for horizontal spacing, padding, icon sizes)
  static double w(BuildContext context, double value) =>
      value * widthScale(context);

  /// Scale a value by height (good for vertical spacing, fixed heights)
  static double h(BuildContext context, double value) =>
      value * heightScale(context);

  /// Scaled font size (capped so text doesn't get too large on big phones)
  static double sp(BuildContext context, double size) {
    final scale = widthScale(context);
    return (size * scale).clamp(size * 0.9, size * 1.2);
  }

  /// Width as percentage of screen (0.0 - 1.0)
  static double wp(BuildContext context, double fraction) =>
      width(context) * fraction;

  /// Height as percentage of screen (0.0 - 1.0)
  static double hp(BuildContext context, double fraction) =>
      height(context) * fraction;

  /// Consistent horizontal screen padding for content
  static double horizontalPadding(BuildContext context) => w(context, 16);

  /// Safe area insets
  static EdgeInsets safePadding(BuildContext context) =>
      _mediaQuery(context).padding;

  /// Bottom safe area (e.g. home indicator)
  static double safeBottom(BuildContext context) =>
      _mediaQuery(context).padding.bottom;

  /// Top safe area (e.g. status bar / notch)
  static double safeTop(BuildContext context) =>
      _mediaQuery(context).padding.top;

  /// Scaled bottom nav bar height (for padding content above it)
  static double bottomNavBarHeight(BuildContext context) => h(context, 80);

  /// Scaled sticky header height for home
  static double stickyHeaderHeight(BuildContext context) => h(context, 140);

  /// Is small phone (width < 360)
  static bool isSmallPhone(BuildContext context) =>
      width(context) < breakpointMobile;

  /// Is large phone (width >= 400)
  static bool isLargePhone(BuildContext context) =>
      width(context) >= breakpointMobileLarge;

  /// Is tablet or larger (width >= 600)
  static bool isTablet(BuildContext context) =>
      width(context) >= breakpointTablet;

  /// Is desktop or larger (width >= 900)
  static bool isDesktop(BuildContext context) =>
      width(context) >= breakpointDesktop;

  /// Get current context from GetX (use when inside GetView/GetWidget and context may be needed for responsive values)
  static BuildContext? get context => Get.context;
}

/// GetX controller for reactive responsive values (e.g. in Obx when context is not available).
/// Put [ResponsiveController] in bindings and use [ResponsiveController.to] for screen dimensions.
class ResponsiveController extends GetxController {
  static ResponsiveController get to => Get.find<ResponsiveController>();

  final screenWidth = 375.0.obs;
  final screenHeight = 812.0.obs;

  void updateDimensions(Size size) {
    screenWidth.value = size.width;
    screenHeight.value = size.height;
  }

  double get widthScale => (screenWidth.value / 375.0).clamp(0.85, 1.35);
  double get heightScale => (screenHeight.value / 812.0).clamp(0.85, 1.35);
  double w(double value) => value * widthScale;
  double h(double value) => value * heightScale;
  double sp(double size) => (size * widthScale).clamp(size * 0.9, size * 1.2);
  bool get isTablet => screenWidth.value >= 600;
  bool get isDesktop => screenWidth.value >= 900;
}

/// Extension to use Responsive easily from BuildContext
extension ResponsiveExtension on BuildContext {
  double get screenWidth => Responsive.width(this);
  double get screenHeight => Responsive.height(this);
  double rw(double value) => Responsive.w(this, value);
  double rh(double value) => Responsive.h(this, value);
  double rsp(double size) => Responsive.sp(this, size);
  double wp(double fraction) => Responsive.wp(this, fraction);
  double hp(double fraction) => Responsive.hp(this, fraction);
  double get horizontalPadding => Responsive.horizontalPadding(this);
  EdgeInsets get safePadding => Responsive.safePadding(this);
  double get safeBottom => Responsive.safeBottom(this);
  double get safeTop => Responsive.safeTop(this);
  double get bottomNavBarHeight => Responsive.bottomNavBarHeight(this);
  double get stickyHeaderHeight => Responsive.stickyHeaderHeight(this);
}
