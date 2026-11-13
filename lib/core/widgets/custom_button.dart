import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/dimensions.dart';
import '../theme/app_colors.dart';

enum ButtonStyleType { filled, outlined, text, gradient }
enum GradientButtonType { filled, outlined, text }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? textStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ButtonStyleType buttonType;
  final Color? borderColor;

  /// Gradient options
  final Gradient? gradient;
  final GradientButtonType? gradientType;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.textStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.buttonType = ButtonStyleType.filled,
    this.borderColor,
    this.gradient,
    this.gradientType,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius ?? Dimensions.radius8);

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? Dimensions.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: _getButtonStyle(radius),
        child: isLoading
            ? const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : _buildChild(radius),
      ),
    );
  }

  /// child widget (normal / gradient variations)
  Widget _buildChild(BorderRadius radius) {
    if (buttonType == ButtonStyleType.gradient) {
      final mode = gradientType ?? GradientButtonType.filled;
      final g = gradient ??
          const LinearGradient(
            colors: [Color(0xFF524040), Color(0xFF070706)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );

      switch (mode) {
        case GradientButtonType.filled:
          return Ink(
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: g,
            ),
            child: Center(
              child: Text(
                text,
                style: textStyle ??
                    TextStyle(
                      color: textColor ?? Colors.white,
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          );

        case GradientButtonType.outlined:
          return Ink(
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(width: 2, color: Colors.transparent),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => g.createShader(bounds),
                child: Text(
                  text,
                  style: textStyle ??
                      TextStyle(
                        fontSize: Dimensions.font16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white, // masked by shader
                      ),
                ),
              ),
            ),
          );

        case GradientButtonType.text:
          return Center(
            child: ShaderMask(
              shaderCallback: (bounds) => g.createShader(bounds),
              child: Text(
                text,
                style: textStyle ??
                    TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white, // masked by shader
                    ),
              ),
            ),
          );
      }
    }

    // normal (filled / outlined / text)
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          prefixIcon!,
          SizedBox(width: Dimensions.width10),
        ],
        Flexible(
          child: Text(
            text,
            style: textStyle ??
                TextStyle(
                  color: _getTextColor(),
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        if (suffixIcon != null) ...[
          SizedBox(width: Dimensions.width10),
          suffixIcon!,
        ],
      ],
    );
  }

  /// text color
  Color _getTextColor() {
    if (textColor != null) return textColor!;
    return switch (buttonType) {
      ButtonStyleType.outlined || ButtonStyleType.text => AppColors.primaryColor,
      _ => Colors.white,
    };
  }

  /// button style
  ButtonStyle _getButtonStyle(BorderRadius radius) {
    final base = ElevatedButton.styleFrom(
      padding: padding ?? EdgeInsets.symmetric(vertical: Dimensions.height15),
      shape: RoundedRectangleBorder(borderRadius: radius),
    );

    return switch (buttonType) {
      ButtonStyleType.outlined => base.copyWith(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        side: MaterialStateProperty.all(
          BorderSide(color: borderColor ?? AppColors.primaryColor, width: 1.5),
        ),
        foregroundColor: MaterialStateProperty.all(textColor ?? AppColors.primaryColor),
      ),
      ButtonStyleType.text => base.copyWith(
        elevation: MaterialStateProperty.all(0),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        foregroundColor: MaterialStateProperty.all(textColor ?? AppColors.primaryColor),
      ),
      ButtonStyleType.gradient => base.copyWith(
        padding: MaterialStateProperty.all(EdgeInsets.zero),
        backgroundColor: MaterialStateProperty.all(Colors.transparent),
        shadowColor: MaterialStateProperty.all(Colors.black54),
        elevation: MaterialStateProperty.all(6),
      ),
      _ => base.copyWith(
        backgroundColor: MaterialStateProperty.resolveWith((states) =>
        states.contains(MaterialState.disabled)
            ? (backgroundColor ?? AppColors.primaryColor).withOpacity(0.6)
            : backgroundColor ?? AppColors.primaryColor),
        foregroundColor: MaterialStateProperty.all(textColor ?? Colors.white),
      ),
    };
  }
}
