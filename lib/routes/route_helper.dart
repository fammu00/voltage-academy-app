import 'package:get/get.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/splash/screens/intro_splash_screen.dart';
import '../features/splash/screens/welcome_webview_screen.dart';
import 'app_routes.dart';

class RouteHelper {
  static String getSplashRoute() => AppRoutes.splash;
  static String getIntroRoute() => AppRoutes.intro;
  static String getWebviewRoute() => AppRoutes.webview;

  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.intro,
      page: () => const IntroSplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.webview,
      page: () => const WelcomeWebViewScreen(),
      transition: Transition.fadeIn,
    ),
  ];
}
