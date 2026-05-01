import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();

  final _mode = ThemeMode.system.obs;

  ThemeMode get themeMode => _mode.value;
  bool get isDark => _mode.value == ThemeMode.dark;

  void toggleTheme() {
    final next = isDark ? ThemeMode.light : ThemeMode.dark;
    _mode.value = next;
    Get.changeThemeMode(next);
  }

  void setTheme(ThemeMode mode) {
    _mode.value = mode;
    Get.changeThemeMode(mode);
  }
}