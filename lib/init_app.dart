import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/services/config/env_config.dart';
import 'core/theme/theme_controller.dart';
import 'core/services/storage/shared_prefs.dart';

Future<void> initApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  await SharedPrefs.init();

  Get.put(ThemeController());
}
