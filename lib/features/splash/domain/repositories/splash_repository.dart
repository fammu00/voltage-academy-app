import '../../../../core/services/network/api_client.dart';
import 'splash_repository_interface.dart';

class SplashRepository implements SplashRepositoryInterface {
  final ApiClient _apiClient;

  SplashRepository(this._apiClient);

  @override
  Future<bool> checkAppVersion() async {
    // This would typically call an API to check app version
    // For now, we'll just return true
    return true;
  }

  @override
  Future<bool> checkAppMaintenanceStatus() async {
    // This would typically call an API to check maintenance status
    // For now, we'll just return false (not in maintenance)
    return false;
  }
}
