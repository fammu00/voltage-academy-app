import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResponsiveHelper {
  static bool isMobile() {
    return Get.context!.width < 650;
  }

  static bool isTab() {
    return Get.context!.width < 1300 && Get.context!.width >= 650;
  }

  static bool isDesktop() {
    return Get.context!.width >= 1300;
  }

  static double getScreenHeight() {
    return Get.context!.height;
  }

  static double getScreenWidth() {
    return Get.context!.width;
  }

  static double getPercentageWidth(double percentage) {
    return Get.context!.width * (percentage / 100);
  }

  static double getPercentageHeight(double percentage) {
    return Get.context!.height * (percentage / 100);
  }

  static Widget responsiveBuilder({
    required Widget mobile,
    Widget? tab,
    Widget? desktop,
  }) {
    if (isDesktop() && desktop != null) {
      return desktop;
    } else if (isTab() && tab != null) {
      return tab;
    } else {
      return mobile;
    }
  }
}
