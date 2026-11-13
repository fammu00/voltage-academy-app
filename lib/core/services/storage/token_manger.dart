import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../constants/app_constants.dart';

class TokenManager {
  static const _secureStorage = FlutterSecureStorage();

  static Future<String> getToken() async {
    return await _secureStorage.read(key: AppConstants.token) ?? '';
  }

  static Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConstants.token, value: token);
  }

  static Future<void> clearToken() async {
    await _secureStorage.delete(key: AppConstants.token);
  }
}
