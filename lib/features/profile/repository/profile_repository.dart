import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/auth_session_service.dart';
import '../../auth/models/auth_user.dart';
import '../models/student_profile_model.dart';

class ProfileRepository {
  static ProfileRepository? _instance;
  static ProfileRepository get instance => _instance ??= ProfileRepository._internal();

  final DatabaseService _db;
  final ApiClient _apiClient;
  StudentProfileModel? _profile;

  ProfileRepository({DatabaseService? db, ApiClient? apiClient})
      : _db = db ?? DatabaseService(),
        _apiClient = apiClient ?? ApiClient();

  ProfileRepository._internal()
      : _db = DatabaseService.instance,
        _apiClient = ApiClient();

  StudentProfileModel get currentProfile {
    return _profile ?? _db.getActiveProfile() ?? StudentProfileModel.defaultProfile;
  }

  /// Fetches profile from API: https://awsdemo.co.in/innovateconnect/api/v1/user/profile
  /// Falls back to local database or default profile on network failure
  Future<StudentProfileModel> fetchProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);
      if (response != null) {
        final profile = StudentProfileModel.fromJson(
          response is Map<String, dynamic> ? response : {},
        );
        _profile = profile;
        _db.saveProfile(profile);
        return profile;
      }
    } catch (_) {
      // Graceful fallback to local cache
    }

    final active = _db.getActiveProfile();
    if (active != null) {
      _profile = active;
      return _profile!;
    }
    if (_profile != null) return _profile!;
    return StudentProfileModel.defaultProfile;
  }

  /// Updates profile via API: https://awsdemo.co.in/innovateconnect/api/v1/user/profile
  Future<bool> updateProfile(StudentProfileModel updatedProfile) async {
    _profile = updatedProfile;
    _db.saveProfile(updatedProfile);

    try {
      final payload = {
        'name': updatedProfile.name,
        'email': updatedProfile.email,
        'phone': updatedProfile.phone,
        'field': updatedProfile.field,
        'category': updatedProfile.field,
      };

      try {
        await _apiClient.post(ApiEndpoints.userProfile, body: payload);
      } catch (_) {
        // Fallback to PUT if backend router uses PUT
        await _apiClient.put(ApiEndpoints.userProfile, body: payload);
      }
      return true;
    } catch (_) {
      // Local changes are saved even when network is offline
      return true;
    }
  }

  Future<bool> updateAvatar(String avatarPath) async {
    final current = await fetchProfile();
    final updated = current.copyWith(avatarUrl: avatarPath);
    return updateProfile(updated);
  }

  Future<void> onUserRegistered({
    required String name,
    required String email,
    String? phone,
    String? field,
  }) async {
    final profile = StudentProfileModel(
      name: name.trim(),
      email: email.trim(),
      phone: phone?.trim() ?? '',
      field: field?.trim() ?? '',
      degree: '',
      year: '',
      cohort: 'Student Cohort • 2025',
      isMsmeVerified: true,
      isEmailVerified: true,
    );
    _profile = profile;
    _db.saveProfile(profile);
    _db.setActiveUserEmail(email.trim());
  }

  Future<void> onUserLoggedIn({
    required String email,
    AuthUser? authUser,
  }) async {
    final savedProfile = _db.getProfileForUser(email);
    if (savedProfile != null) {
      _profile = savedProfile;
      _db.setActiveUserEmail(email);
    } else {
      final profile = StudentProfileModel(
        name: authUser?.name.isNotEmpty == true ? authUser!.name : email.split('@').first,
        email: email.trim(),
        phone: authUser?.phone ?? '',
        field: authUser?.field ?? '',
        degree: '',
        year: '',
        cohort: 'Student Cohort • 2025',
        isMsmeVerified: true,
        isEmailVerified: true,
      );
      _profile = profile;
      _db.saveProfile(profile);
      _db.setActiveUserEmail(email);
    }
  }

  Future<void> restoreActiveSession() async {
    final active = _db.getActiveProfile();
    if (active != null) {
      _profile = active;
      return;
    }
    final sessionUser = AuthSessionService.instance.user;
    if (sessionUser != null) {
      await onUserLoggedIn(
        email: sessionUser.email,
        authUser: sessionUser,
      );
    }
  }

  Future<void> logout() async {
    _profile = null;
    _db.clearActiveSession();
    await AuthSessionService.instance.clearSession();
  }

  static void resetInstance() {
    _instance = null;
  }
}
