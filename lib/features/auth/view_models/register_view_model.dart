import '../../../core/base/base_view_model.dart';
import '../models/auth_response.dart';
import '../models/auth_user.dart';
import '../models/auth_token.dart';
import '../repository/auth_repository.dart';

class RegisterViewModel extends BaseViewModel {
  final AuthRepository _repository;

  RegisterViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  AuthUser? _user;
  AuthToken? _token;

  AuthUser? get user => _user;
  AuthToken? get token => _token;

  Future<AuthResponse> register({
    required String name,
    required String email,
    String? phone,
    required String field,
    required String password,
    String? resumePath,
    List<int>? resumeBytes,
    String? resumeFileName,
  }) async {
    setBusy(true);

    try {
      final response = await _repository.register(
        name: name,
        email: email,
        phone: phone,
        field: field,
        password: password,
        resumePath: resumePath,
        resumeBytes: resumeBytes,
        resumeFileName: resumeFileName,
      );

      if (response.status) {
        _user = response.user;
        _token = response.token;
        clearError();
        setSuccess();
      } else {
        setError(response.firstErrorMessage);
      }

      return response;
    } catch (e) {
      setError(e.toString());
      return AuthResponse(status: false, message: e.toString());
    } finally {
      setBusy(false);
    }
  }
}
