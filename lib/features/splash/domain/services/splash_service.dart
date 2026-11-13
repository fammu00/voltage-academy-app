import '../repositories/splash_repository.dart';
import 'splash_service_interface.dart';

class SplashService implements SplashServiceInterface {
  final SplashRepository _splashRepository;

  SplashService(this._splashRepository);

  @override
  Future<bool> initialize() async {
    // Check app version and maintenance status
    final isLatestVersion = await _splashRepository.checkAppVersion();
    final isInMaintenance = await _splashRepository.checkAppMaintenanceStatus();

    // Return true if everything is OK
    return isLatestVersion && !isInMaintenance;
  }
}
