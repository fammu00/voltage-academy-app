import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'text_theme.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: AppColors.darkPrimaryColor,
  scaffoldBackgroundColor: AppColors.darkScaffoldBackgroundColor,
  colorScheme: ColorScheme.dark(
    primary: AppColors.darkPrimaryColor,
    secondary: AppColors.darkSecondaryColor,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    background: AppColors.darkBackgroundColor,
    surface: AppColors.darkCardColor,
    error: AppColors.errorColor,
  ),
  cardColor: AppColors.darkCardColor,
  dividerColor: AppColors.darkDividerColor,
  textTheme: AppTextTheme.darkTextTheme,
  appBarTheme: AppBarTheme(
    elevation: 0,
    color: AppColors.darkPrimaryColor,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    fillColor: AppColors.darkCardColor,
    filled: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkBorderColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkBorderColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.darkPrimaryColor, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppColors.errorColor),
    ),
    hintStyle: TextStyle(color: AppColors.darkTextColorHint),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.darkPrimaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
    ),
  ),
);
