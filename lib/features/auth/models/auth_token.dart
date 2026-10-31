class AuthToken {
  final String tokenType;
  final String token;
  final int expiresIn;

  const AuthToken({
    required this.tokenType,
    required this.token,
    required this.expiresIn,
  });

  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      tokenType: json['token_type'] as String? ?? 'Bearer',
      token: json['token'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_type': tokenType,
      'token': token,
      'expires_in': expiresIn,
    };
  }
}
