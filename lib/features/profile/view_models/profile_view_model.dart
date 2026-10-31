import '../../../core/base/base_view_model.dart';
import '../../auth/models/auth_user.dart';
import '../models/student_profile_model.dart';
import '../repository/profile_repository.dart';

class ProfileViewModel extends BaseViewModel {
  static ProfileViewModel? _instance;
  static ProfileViewModel get instance => _instance ??= ProfileViewModel._internal();

  final ProfileRepository _repository;

  ProfileViewModel({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository() {
    _profile = _repository.currentProfile;
  }

  ProfileViewModel._internal()
      : _repository = ProfileRepository.instance {
    _profile = _repository.currentProfile;
  }

  late StudentProfileModel _profile;

  StudentProfileModel get profile => _profile;

  Future<void> fetchProfile() async {
    setBusy(true);
    try {
      _profile = await _repository.fetchProfile();
      clearError();
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  Future<void> updateField({
    String? name,
    String? email,
    String? phone,
    String? field,
    String? university,
    String? degree,
    String? year,
    String? avatarUrl,
  }) async {
    _profile = _profile.copyWith(
      name: name,
      email: email,
      phone: phone,
      field: field ?? university,
      university: university ?? field,
      degree: degree,
      year: year,
      avatarUrl: avatarUrl,
    );
    await _repository.updateProfile(_profile);
    notifyListeners();
  }

  Future<void> saveRegisteredProfile(StudentProfileModel newProfile) async {
    _profile = newProfile;
    await _repository.updateProfile(newProfile);
    notifyListeners();
  }

  Future<void> onUserRegistered({
    required String name,
    required String email,
    String? phone,
    String? field,
  }) async {
    await _repository.onUserRegistered(
      name: name,
      email: email,
      phone: phone,
      field: field,
    );
    _profile = _repository.currentProfile;
    notifyListeners();
  }

  Future<void> onUserLoggedIn({
    required String email,
    AuthUser? authUser,
  }) async {
    await _repository.onUserLoggedIn(
      email: email,
      authUser: authUser,
    );
    _profile = _repository.currentProfile;
    notifyListeners();
  }

  Future<void> restoreActiveSession() async {
    await _repository.restoreActiveSession();
    _profile = _repository.currentProfile;
    notifyListeners();
  }

  Future<void> logout() async {
    await _repository.logout();
    _profile = _repository.currentProfile;
    notifyListeners();
  }

  static void reset() {
    _instance = null;
  }
}
