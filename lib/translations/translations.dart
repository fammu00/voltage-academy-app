// lib/translations/translations.dart
import 'package:get/get.dart';
import '../core/services/translations/translation_loader.dart';

class AppTranslations extends Translations {
  // Internal data store
  final Map<String, Map<String, String>> _translations = {};

  // Override the keys getter to return our loaded translations
  @override
  Map<String, Map<String, String>> get keys => _translations;

  // Load translations dynamically
  static Future<AppTranslations> load() async {
    final instance = AppTranslations();

    // Load translations for each supported locale
    final enUS = await TranslationLoader.load('en_US');
    final hiIN = await TranslationLoader.load('hi_IN');

    // Add translations to our internal map
    instance._translations.addAll({
      'en_US': enUS,
      'hi_IN': hiIN,
    });

    return instance;
  }
}

