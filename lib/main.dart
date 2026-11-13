import 'package:hash_code/core/constants/app_constants.dart';
import 'package:hash_code/core/theme/dark_theme.dart';
import 'package:hash_code/core/theme/light_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/theme/theme_controller.dart';
import 'init_app.dart';
import 'routes/route_helper.dart';
import 'core/bindings/initial_bindings.dart';
import 'core/services/storage/shared_prefs.dart';

void main() async {
  await initApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Obx(() => GetMaterialApp(
      title: 'Voltage Academy',
      debugShowCheckedModeBanner: false,
      navigatorKey: Get.key,
      initialBinding: InitialBindings(),
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeController.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      initialRoute: RouteHelper.getSplashRoute(),
      getPages: RouteHelper.routes,
      defaultTransition: Transition.fadeIn,
    ));
  }
}
