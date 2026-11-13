class AppValidators {
  // Regex patterns
  static final _mobileRegex = RegExp(r'^[0-9]{10}$');
  static final _emailRegex =
  RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  /// Validate if field is not empty
  static String? validateEmpty(
      String? value, {
        String fieldName = "Field",
        String? customMessage,
      }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) {
      return customMessage ?? "$fieldName is required";
    }
    return null;
  }

  /// Validate mobile number (default 10 digits)
  static String? validateMobile(
      String? value, {
        int length = 10,
        String? customMessage,
      }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) {
      return "Mobile number is required";
    }
    final pattern = RegExp(r'^[0-9]{' + length.toString() + r'}$');
    if (!pattern.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid $length-digit mobile number";
    }
    return null;
  }

  /// Validate email
  static String? validateEmail(
      String? value, {
        String? customMessage,
      }) {
    final trimmed = value?.trim() ?? "";
    if (trimmed.isEmpty) {
      return "Email is required";
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      return customMessage ?? "Enter a valid email address";
    }
    return null;
  }
}
