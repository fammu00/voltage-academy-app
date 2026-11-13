import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dimensions {
  // Make these getters instead of static variables
  static double get screenHeight {
    return 800;  // Use Get.height instead of Get.context!.height
    // return Get.height;  // Use Get.height instead of Get.context!.height
  }

  static double get screenWidth {
    return 350;  // Use Get.width instead of Get.context!.width
    // return Get.width;  // Use Get.width instead of Get.context!.width
  }

  // Dynamic height padding and margin - convert to getters
  static double get height5 => screenHeight / 168.8;
  static double get height10 => screenHeight / 84.4;
  static double get height15 => screenHeight / 56.27;
  static double get height20 => screenHeight / 42.2;
  static double get height30 => screenHeight / 28.13;
  static double get height45 => screenHeight / 18.76;

  // Dynamic width padding and margin
  static double get width5 => screenHeight / 168.8;
  static double get width10 => screenHeight / 84.4;
  static double get width15 => screenHeight / 56.27;
  static double get width20 => screenHeight / 42.2;
  static double get width30 => screenHeight / 28.13;

  // Font sizes
  static double get font12 => screenHeight / 70.33;
  static double get font14 => screenHeight / 60.29;
  static double get font16 => screenHeight / 52.75;
  static double get font18 => screenHeight / 46.89;
  static double get font20 => screenHeight / 42.2;
  static double get font24 => screenHeight / 35.17;

  // Radius
  static double get radius8 => screenHeight / 105.5;
  static double get radius12 => screenHeight / 70.33;
  static double get radius15 => screenHeight / 56.27;
  static double get radius20 => screenHeight / 42.2;
  static double get radius30 => screenHeight / 28.13;

  // Icon Size
  static double get iconSize16 => screenHeight / 52.75;
  static double get iconSize20 => screenHeight / 42.2;
  static double get iconSize24 => screenHeight / 35.17;

  // Button sizes
  static double get buttonHeight => screenHeight / 14.07;
  static double get buttonWidth => screenWidth / 2.06;

  // List view size
  static double get listViewImgSize => screenWidth / 3.25;
  static double get listViewTextContSize => screenWidth / 3.9;
}
