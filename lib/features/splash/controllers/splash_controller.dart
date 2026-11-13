import 'dart:async';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../routes/route_helper.dart';
import '../domain/services/splash_service.dart';
import '../../../core/services/storage/shared_prefs.dart';

class SplashController extends GetxController {
  final SplashService _splashService;

  SplashController(this._splashService);

  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    initApp();
  }

  Future<void> initApp() async {
    try {
      isLoading.value = true;

      // Initialize splash service
      await _splashService.initialize();

      // Reset splash_seen if the app version changed (fresh install / update)
      await _resetIfVersionChanged();

      // Wait for 5 seconds to show the premium splash screen
      await Future.delayed(const Duration(seconds: 5));

      _navigateNext();
    } catch (e) {
      _navigateNext();
    } finally {
      isLoading.value = false;
    }
  }

  /// Clears splash_seen when the app version changes so the intro screen
  /// always shows on a fresh install or after a version update.
  Future<void> _resetIfVersionChanged() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = '${info.version}+${info.buildNumber}';
      final savedVersion = SharedPrefs.getString('app_version') ?? '';

      if (savedVersion != currentVersion) {
        // New install or updated version — reset intro flag
        await SharedPrefs.setBool('splash_seen', false);
        await SharedPrefs.setString('app_version', currentVersion);
      }
    } catch (_) {
      // If version check fails, just proceed normally
    }
  }

  void _navigateNext() {
    if (SharedPrefs.getBool('splash_seen') == true) {
      Get.offAllNamed(RouteHelper.getWebviewRoute());
    } else {
      Get.offAllNamed(RouteHelper.getIntroRoute());
    }
  }
}
