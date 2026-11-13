import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';

class CustomToast {
  static void show(
      String message, {
        Duration duration = const Duration(seconds: 2),
        Color backgroundColor = AppColors.primaryColor,
        Color? textColor,
        double width = 0.8,
      }) {
    final double screenWidth = Get.width;
    final double toastWidth = screenWidth * width;

    // Auto text color for readability
    final Color effectiveTextColor = textColor ??
        (backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white);

    final Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        message,
        style: TextStyle(color: effectiveTextColor, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );

    final Widget overlay = Positioned(
      bottom: 50,
      left: (screenWidth - toastWidth) / 2,
      width: toastWidth,
      child: SafeArea(
        child: Material(
          color: Colors.transparent,
          child: AnimatedOpacity(
            opacity: 1.0,
            duration: const Duration(milliseconds: 200),
            child: toast,
          ),
        ),
      ),
    );

    final OverlayState? overlayState = Overlay.of(Get.context!);
    final OverlayEntry entry = OverlayEntry(builder: (_) => overlay);

    overlayState?.insert(entry);

    // Fade out animation before removal
    Future.delayed(duration - const Duration(milliseconds: 200), () {
      entry.markNeedsBuild();
    });
    Future.delayed(duration, () {
      entry.remove();
    });
  }

  static void showSuccess(String message) =>
      show(message, backgroundColor: AppColors.successColor);

  static void showError(String message) =>
      show(message, backgroundColor: AppColors.errorColor);

  static void showWarning(String message) =>
      show(message, backgroundColor: AppColors.warningColor);

  static void showInfo(String message) =>
      show(message, backgroundColor: AppColors.infoColor);
}
