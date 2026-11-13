// lib/core/services/translations/translation_loader.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class TranslationLoader {
  // Load a translation file for a specific locale
  static Future<Map<String, String>> load(String locale) async {
    final jsonString = await rootBundle.loadString('assets/translations/$locale.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Convert Map<String, dynamic> to Map<String, String>
    Map<String, String> translations = {};
    jsonMap.forEach((key, value) {
      translations[key] = value.toString();
    });

    return translations;
  }
}
