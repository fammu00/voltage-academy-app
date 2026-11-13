import 'package:flutter/material.dart';
import '../constants/dimensions.dart';

class Styles {
  // Primary button style
  static ButtonStyle primaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary,
      foregroundColor: theme.colorScheme.onPrimary,
      minimumSize: Size(double.infinity, Dimensions.buttonHeight),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
      ),
    );
  }

  // Secondary button style
  static ButtonStyle secondaryButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.onPrimary,
      foregroundColor: theme.colorScheme.primary,
      minimumSize: Size(double.infinity, Dimensions.buttonHeight),
      padding: EdgeInsets.symmetric(vertical: Dimensions.height15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        side: BorderSide(color: theme.colorScheme.primary),
      ),
    );
  }

  // Heading TextStyle
  static TextStyle headingStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(
      fontSize: Dimensions.font20,
      fontWeight: FontWeight.bold,
    );
  }

  // Subheading TextStyle
  static TextStyle subHeadingStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(
      fontSize: Dimensions.font16,
      fontWeight: FontWeight.w500,
    );
  }

  // Body text
  static TextStyle bodyTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(
      fontSize: Dimensions.font14,
    );
  }

  // Small text
  static TextStyle smallTextStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(
      fontSize: Dimensions.font12,
    );
  }

  // Input decoration
  static InputDecoration inputDecoration(
      BuildContext context, {
        required String hintText,
        Widget? prefixIcon,
        Widget? suffixIcon,
      }) {
    final theme = Theme.of(context);
    return InputDecoration(
      hintText: hintText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: theme.colorScheme.surface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: Dimensions.width15,
        vertical: Dimensions.height15,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius8),
        borderSide: BorderSide(color: theme.colorScheme.error),
      ),
    );
  }
}
