import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../constants/app_constants.dart';
import '../services/storage/shared_prefs.dart';
import 'light_theme.dart';
import 'dark_theme.dart';

class ThemeController extends GetxController with WidgetsBindingObserver {
  final _isDarkMode = false.obs;
  bool _isUserOverride = false;

  bool get isDarkMode => _isDarkMode.value;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this); // ensure observer is registered
    _initTheme(); // no need for external call
  }

  Future<void> _initTheme() async {
    final themeValue = SharedPrefs.getBool(AppConstants.theme);

    if (themeValue != null) {
      _isDarkMode.value = themeValue;
      _isUserOverride = true;
    } else {
      _setThemeBasedOnSystem(); // use system theme if no preference saved
    }

    _applyTheme();
  }

  void _setThemeBasedOnSystem() {
    final Brightness systemBrightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;

    print("System brightness: $systemBrightness");

    _isDarkMode.value = systemBrightness == Brightness.dark;
  }

  void _applyTheme() {
    Get.changeTheme(_isDarkMode.value ? darkTheme : lightTheme);
    update(); // notify builder
  }

  @override
  void didChangePlatformBrightness() {
    print("System theme changed");

    if (!_isUserOverride) {
      _setThemeBasedOnSystem();
      _applyTheme();
    }
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    _isUserOverride = true;
    SharedPrefs.setBool(AppConstants.theme, _isDarkMode.value);
    _applyTheme();
  }

  void followSystemTheme() {
    _isUserOverride = false;
    SharedPrefs.remove(AppConstants.theme);
    _setThemeBasedOnSystem();
    _applyTheme();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
