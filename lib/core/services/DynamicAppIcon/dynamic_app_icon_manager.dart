import 'dart:convert';
import 'dart:io';
import 'package:flutter_dynamic_icon_plus/flutter_dynamic_icon_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class DynamicAppIconManager {
  static const String defaultIcon = 'ic_launcher'; // Default app icon name

  /// Fetch icon info from backend
  static Future<Map<String, String>> fetchBackendIcon() async {
    try {
      // Uncomment this to fetch from server
      /*
      final response = await http.get(Uri.parse('https://yourserver.com/icon.json'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'iconName': data['iconName'] ?? defaultIcon,
          'iconUrl': data['iconUrl'] ?? '',
        };
      }
      */

      // Mock data for testing
      final mockResponse = {
        "iconName": "ic_alternate", // Example alternate icon name
        "iconUrl": "https://dummyimage.com/512x512/000/fff.png&text=icon_1" // Example URL
      };
      return {
        'iconName': mockResponse['iconName'] ?? defaultIcon,
        'iconUrl': mockResponse['iconUrl'] ?? '',
      };
    } catch (e) {
      print("Backend fetch failed: $e");
      return {
        'iconName': defaultIcon,
        'iconUrl': '',
      };
    }
  }

  /// Download icon for Android if needed
  static Future<File?> downloadAndroidIcon(String url, String fileName) async {
    if (url.isEmpty) return null;
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$fileName.png');
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print("Download failed: $e");
    }
    return null;
  }

  /// Set app icon (iOS + Android)
  static Future<void> setAppIcon({required String iconName}) async {
    try {
      if (await FlutterDynamicIconPlus.supportsAlternateIcons) {
        await FlutterDynamicIconPlus.setAlternateIconName(iconName: iconName);
        print("Icon set: $iconName");
      }
    } catch (e) {
      print("Failed to set icon: $e");
    }
  }

  /// Initialize at app launch
  static Future<void> init() async {
    final backendIcon = await fetchBackendIcon();
    final iconName = backendIcon['iconName'] ?? defaultIcon;

    // Android: download icon if URL provided
    if (Platform.isAndroid && (backendIcon['iconUrl']?.isNotEmpty ?? false)) {
      await downloadAndroidIcon(backendIcon['iconUrl']!, iconName);
    }

    // Set icon (fallback to default handled by backendIcon)
    await setAppIcon(iconName: iconName);
  }
}
