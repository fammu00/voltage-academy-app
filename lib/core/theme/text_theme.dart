import 'package:flutter/material.dart';
import '../constants/dimensions.dart';
import 'app_colors.dart';

class AppTextTheme {
  static TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: Dimensions.font24,
      fontWeight: FontWeight.bold,
      color: AppColors.textColorPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: Dimensions.font20,
      fontWeight: FontWeight.w600,
      color: AppColors.textColorPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: Dimensions.font18,
      fontWeight: FontWeight.w500,
      color: AppColors.textColorPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
      color: AppColors.textColorPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
      color: AppColors.textColorPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.normal,
      color: AppColors.textColorPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.normal,
      color: AppColors.textColorSecondary,
    ),
    titleMedium: TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.w500,
      color: AppColors.textColorPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: Dimensions.font12,
      fontWeight: FontWeight.normal,
      color: AppColors.textColorSecondary,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: Dimensions.font24,
      fontWeight: FontWeight.bold,
      color: AppColors.darkTextColorPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: Dimensions.font20,
      fontWeight: FontWeight.w600,
      color: AppColors.darkTextColorPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: Dimensions.font18,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextColorPrimary,
    ),
    headlineMedium: TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextColorPrimary,
    ),
    titleLarge: TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextColorPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextColorPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextColorSecondary,
    ),
    titleMedium: TextStyle(
      fontSize: Dimensions.font14,
      fontWeight: FontWeight.w500,
      color: AppColors.darkTextColorPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: Dimensions.font12,
      fontWeight: FontWeight.normal,
      color: AppColors.darkTextColorSecondary,
    ),
  );
}
