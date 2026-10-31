import '../../../core/base/base_view_model.dart';
import '../models/auth_response.dart';
import '../models/auth_user.dart';
import '../models/auth_token.dart';
import '../repository/auth_repository.dart';

class LoginViewModel extends BaseViewModel {
  final AuthRepository _repository;

  LoginViewModel({AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  AuthUser? _user;
  AuthToken? _token;

  AuthUser? get user => _user;
  AuthToken? get token => _token;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    setBusy(true);

    try {
      final response = await _repository.login(
        email: email,
        password: password,
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
