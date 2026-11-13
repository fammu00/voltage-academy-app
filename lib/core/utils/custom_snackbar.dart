import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class CustomSnackbar {
  /// Generic method so all snackbar styles are consistent
  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    Color? textColor,
  }) {
    // Auto-adjust text color for readability
    final Color effectiveTextColor =
        textColor ?? (backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: effectiveTextColor,
      margin: const EdgeInsets.all(12),
      borderRadius: 10,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      icon: Icon(icon, color: effectiveTextColor),
      shouldIconPulse: false,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      mainButton: TextButton(
        onPressed: () => Get.back(),
        child: Text(
          "DISMISS",
          style: TextStyle(color: effectiveTextColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  static void showSuccess(String message, {String title = 'Success'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.successColor,
      icon: Icons.check_circle,
    );
  }

  static void showError(String message, {String title = 'Error'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.errorColor,
      icon: Icons.error,
    );
  }

  static void showInfo(String message, {String title = 'Info'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.infoColor,
      icon: Icons.info,
    );
  }

  static void showWarning(String message, {String title = 'Warning'}) {
    _show(
      title: title,
      message: message,
      backgroundColor: AppColors.warningColor,
      icon: Icons.warning,
    );
  }
}
