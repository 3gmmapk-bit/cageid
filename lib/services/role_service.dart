import 'auth_service.dart';

class RoleService {
  final AuthService authService = AuthService();

  Future<bool> isSuperAdmin() async {
    return await authService.getUserRole() ==
        'Super Admin';
  }

  Future<bool> isPromotionAdmin() async {
    return await authService.getUserRole() ==
        'Promotion Admin';
  }

  Future<bool> isGymAdmin() async {
    return await authService.getUserRole() ==
        'Gym Admin';
  }

  Future<bool> canManageAthletes() async {
    final role = await authService.getUserRole();

    return role == 'Super Admin' ||
        role == 'Gym Admin';
  }

  Future<bool> canManageEvents() async {
    final role = await authService.getUserRole();

    return role == 'Super Admin' ||
        role == 'Promotion Admin';
  }

  Future<bool> canPublishNews() async {
    final role = await authService.getUserRole();

    return role == 'Super Admin' ||
        role == 'Promotion Admin';
  }

  Future<bool> canUploadMedia() async {
    final role = await authService.getUserRole();

    return role == 'Super Admin' ||
        role == 'Promotion Admin' ||
        role == 'Gym Admin';
  }
}
