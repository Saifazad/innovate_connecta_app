import 'package:flutter_test/flutter_test.dart';
import 'package:innovate_connecta_app/features/auth/models/auth_response.dart';
import 'package:innovate_connecta_app/features/auth/models/auth_token.dart';
import 'package:innovate_connecta_app/features/auth/models/auth_user.dart';

void main() {
  group('Auth Models & Serialization Tests', () {
    test('AuthToken deserializes correctly from API payload', () {
      final json = {
        'token_type': 'Bearer',
        'token': 'jwt_test_token_123',
        'expires_in': 28800,
      };

      final token = AuthToken.fromJson(json);
      expect(token.tokenType, 'Bearer');
      expect(token.token, 'jwt_test_token_123');
      expect(token.expiresIn, 28800);
    });

    test('AuthUser deserializes correctly from API payload', () {
      final json = {
        'id': 13,
        'name': 'Rahul Sharma',
        'email': 'rahul@example.com',
        'phone': '+919876543210',
        'field': 'College Student',
        'resume_path': null,
        'is_active': true,
      };

      final user = AuthUser.fromJson(json);
      expect(user.id, 13);
      expect(user.name, 'Rahul Sharma');
      expect(user.email, 'rahul@example.com');
      expect(user.phone, '+919876543210');
      expect(user.field, 'College Student');
      expect(user.isActive, true);
    });

    test('AuthResponse handles success response properly', () {
      final json = {
        'status': true,
        'message': 'User registered successfully',
        'data': {
          'user': {
            'id': 14,
            'name': 'Rahul Sharma',
            'email': 'rahul@example.com',
            'field': 'College Student',
          },
          'token_type': 'Bearer',
          'token': 'sample_jwt',
          'expires_in': 28800,
        },
      };

      final response = AuthResponse.fromJson(json);
      expect(response.status, true);
      expect(response.message, 'User registered successfully');
      expect(response.user?.name, 'Rahul Sharma');
      expect(response.token?.token, 'sample_jwt');
    });

    test('AuthResponse handles validation error payload properly', () {
      final json = {
        'status': false,
        'message': 'Validation error',
        'errors': {
          'email': ['This email address is already registered.'],
        },
      };

      final response = AuthResponse.fromJson(json);
      expect(response.status, false);
      expect(response.firstErrorMessage, 'This email address is already registered.');
    });
  });
}
