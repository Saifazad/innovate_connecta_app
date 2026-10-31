import 'auth_user.dart';
import 'auth_token.dart';

class AuthResponse {
  final bool status;
  final String message;
  final AuthUser? user;
  final AuthToken? token;
  final Map<String, List<String>>? errors;

  const AuthResponse({
    required this.status,
    required this.message,
    this.user,
    this.token,
    this.errors,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    AuthUser? user;
    AuthToken? token;

    if (json['data'] is Map<String, dynamic>) {
      final data = json['data'] as Map<String, dynamic>;
      if (data['user'] is Map<String, dynamic>) {
        user = AuthUser.fromJson(data['user'] as Map<String, dynamic>);
      }
      token = AuthToken.fromJson(data);
    }

    Map<String, List<String>>? errors;
    if (json['errors'] is Map<String, dynamic>) {
      errors = {};
      final rawErrors = json['errors'] as Map<String, dynamic>;
      rawErrors.forEach((key, value) {
        if (value is List) {
          errors![key] = value.map((e) => e.toString()).toList();
        } else if (value != null) {
          errors![key] = [value.toString()];
        }
      });
    }

    return AuthResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      user: user,
      token: token,
      errors: errors,
    );
  }

  /// Get the first user-friendly error message if available
  String get firstErrorMessage {
    if (errors != null && errors!.isNotEmpty) {
      final firstKey = errors!.keys.first;
      final list = errors![firstKey];
      if (list != null && list.isNotEmpty) {
        return list.first;
      }
    }
    return message.isNotEmpty ? message : 'Something went wrong. Please try again.';
  }
}
