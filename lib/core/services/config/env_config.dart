import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment {
  development,
  staging,
  production,
}

class EnvConfig {
  static late final Environment environment;

  static Future<void> load() async {
    print("load() => ENV Loaded: start");

    await dotenv.load(fileName: '.env');
    print("load() => ENV Loaded: ${dotenv.env['ENV']}");


    final envValue = dotenv.env['ENV']?.toLowerCase();

    switch (envValue) {
      case 'production':
        environment = Environment.production;
        break;
      case 'staging':
        environment = Environment.staging;
        break;
      case 'development':
        environment = Environment.development;
        break;
      default:
        print('load() =>  ENV not found or invalid in .env file. Defaulting to development.');
        environment = Environment.development;
        break;
    }
  }

  static String get baseUrl {
    switch (environment) {
      case Environment.production:
        return dotenv.env['BASE_URL_P'] ?? '';
      case Environment.staging:
        return dotenv.env['BASE_URL_S'] ?? '';
      case Environment.development:
      default:
        return dotenv.env['BASE_URL_D'] ?? '';
    }
  }

  static String get appName {
    return dotenv.env['APP_NAME'] ?? '';
  }
}




// import 'package:hash_code/core/constants/app_constants.dart';
//
// enum Environment {
//   development,
//   staging,
//   production,
// }
//
// class EnvConfig {
//   static Environment environment = Environment.development;
//
//   static String get baseUrl {
//     switch (environment) {
//       case Environment.development:
//         return AppConstants.baseUrl_D;
//       case Environment.staging:
//         return AppConstants.baseUrl_S;
//       case Environment.production:
//         return AppConstants.baseUrl_P;
//     }
//   }
//
//   static bool get isProduction => environment == Environment.production;
//   static bool get isStaging => environment == Environment.staging;
//   static bool get isDevelopment => environment == Environment.development;
//
//   static void setEnvironment(Environment env) {
//     environment = env;
//   }
// }
