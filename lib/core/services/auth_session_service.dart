import 'dart:convert';
import '../../features/auth/models/auth_token.dart';
import '../../features/auth/models/auth_user.dart';
import '../../features/auth/repository/auth_repository.dart';
import 'database_service.dart';
import 'secure_auth_storage.dart';

/// Authentication session manager responsible for persistent auto-login,
/// token lifecycle, secure storage, and session clearing on logout.
class AuthSessionService {
  static AuthSessionService? _instance;
  static AuthSessionService get instance =>
      _instance ??= AuthSessionService(
        storage: SecureAuthStorage.instance,
        db: DatabaseService.instance,
      );

  final SecureAuthStorage _storage;
  final DatabaseService _db;
  final AuthRepository _authRepository;

  static const String keyToken = 'auth_token';
  static const String keyTokenType = 'auth_token_type';
  static const String keyExpiresIn = 'auth_expires_in';
  static const String keyExpiresAt = 'auth_expires_at';
  static const String keyUser = 'auth_user';
  static const String keyUserEmail = 'auth_user_email';

  AuthSessionService({
    SecureAuthStorage? storage,
    DatabaseService? db,
    AuthRepository? authRepository,
  })  : _storage = storage ?? SecureAuthStorage(),
        _db = db ?? DatabaseService(),
        _authRepository = authRepository ?? AuthRepository();

  /// Securely save authentication session (token, expiry, and user profile)
  Future<void> saveSession({
    required AuthToken token,
    required AuthUser user,
  }) async {
    final nowMs = DateTime.now().millisecondsSinceEpoch;
    // Calculate expiration timestamp (default to 30 days if expiresIn <= 0)
    final int validSeconds = token.expiresIn > 0 ? token.expiresIn : 86400 * 30;
    final int expiresAtMs = nowMs + (validSeconds * 1000);

    _storage.writeSync(key: keyToken, value: token.token);
    _storage.writeSync(key: keyTokenType, value: token.tokenType);
    _storage.writeSync(key: keyExpiresIn, value: token.expiresIn.toString());
    _storage.writeSync(key: keyExpiresAt, value: expiresAtMs.toString());
    _storage.writeSync(key: keyUser, value: jsonEncode(user.toJson()));
    _storage.writeSync(key: keyUserEmail, value: user.email.trim());

    // Synchronize active user email with local database
    _db.setActiveUserEmail(user.email.trim());
  }

  /// Check whether a valid, non-expired authentication session exists
  bool hasValidSession() {
    final token = _storage.readSync(keyToken);
    final email = _storage.readSync(keyUserEmail);

    if (token == null || token.trim().isEmpty) {
      return false;
    }
    if (email == null || email.trim().isEmpty) {
      return false;
    }

    // Check if token has expired
    if (isTokenExpired) {
      return false;
    }

    return true;
  }

  /// Whether current session exists but has passed its expiration time
  bool get isTokenExpired {
    final expiresAtStr = _storage.readSync(keyExpiresAt);
    if (expiresAtStr == null || expiresAtStr.isEmpty) {
      return false;
    }

    final expiresAt = int.tryParse(expiresAtStr);
    if (expiresAt == null || expiresAt <= 0) {
      return false;
    }

    return DateTime.now().millisecondsSinceEpoch >= expiresAt;
  }

  /// Check session validity; if expired, attempts token refresh.
  /// Returns true if a valid session is ready, false if re-authentication is required.
  Future<bool> validateOrRefreshSession({AuthRepository? authRepository}) async {
    final token = _storage.readSync(keyToken);
    final email = _storage.readSync(keyUserEmail);

    if (token == null || token.trim().isEmpty || email == null || email.trim().isEmpty) {
      await clearSession();
      return false;
    }

    if (!isTokenExpired) {
      return true;
    }

    // Token has expired, attempt refresh
    final refreshed = await refreshToken(authRepository: authRepository);
    if (refreshed) {
      return true;
    }

    // Refresh failed or unavailable, clear stale session
    await clearSession();
    return false;
  }

  /// Refresh token using repository
  Future<bool> refreshToken({AuthRepository? authRepository}) async {
    final repo = authRepository ?? _authRepository;
    final currentToken = _storage.readSync(keyToken);

    if (currentToken == null || currentToken.trim().isEmpty) {
      await clearSession();
      return false;
    }

    try {
      final response = await repo.refreshToken(token: currentToken);
      if (response.status && response.token != null) {
        final currentUser = user;
        final updatedUser = response.user ?? currentUser;
        if (updatedUser != null) {
          await saveSession(
            token: response.token!,
            user: updatedUser,
          );
          return true;
        }
      }
    } catch (_) {
      // Refresh failed
    }

    return false;
  }

  /// Clear all saved authentication tokens and session data (used on logout)
  Future<void> clearSession() async {
    _storage.deleteAllSync();
    _db.clearActiveSession();
  }

  /// Get the currently saved AuthToken
  AuthToken? get token {
    final tokenStr = _storage.readSync(keyToken);
    if (tokenStr == null || tokenStr.isEmpty) return null;

    final tokenType = _storage.readSync(keyTokenType) ?? 'Bearer';
    final expiresInStr = _storage.readSync(keyExpiresIn);
    final expiresIn = int.tryParse(expiresInStr ?? '0') ?? 0;

    return AuthToken(
      tokenType: tokenType,
      token: tokenStr,
      expiresIn: expiresIn,
    );
  }

  /// Get the currently saved AuthUser
  AuthUser? get user {
    final userJsonStr = _storage.readSync(keyUser);
    if (userJsonStr == null || userJsonStr.isEmpty) return null;

    try {
      final map = jsonDecode(userJsonStr) as Map<String, dynamic>;
      return AuthUser.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  /// Get the saved user email
  String? get userEmail => _storage.readSync(keyUserEmail);

  /// Get the session expiration timestamp in milliseconds since epoch
  int? get expiresAt {
    final expiresAtStr = _storage.readSync(keyExpiresAt);
    if (expiresAtStr == null) return null;
    return int.tryParse(expiresAtStr);
  }

  /// Convenience getter for login status
  bool get isLoggedIn => hasValidSession();

  /// Reset internal state (useful for tests)
  void reset() {
    _storage.reset();
  }

  /// Reset singleton instance
  static void resetInstance() {
    _instance?.reset();
    _instance = null;
  }
}
