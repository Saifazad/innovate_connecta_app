import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/auth_response.dart';

class AuthRepository {
  static const String baseUrl = 'https://awsdemo.co.in/innovateconnect/api/v1';

  final http.Client _client;

  AuthRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Login with email and password
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('$baseUrl/login');

      final response = await _client.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email.trim(),
          'password': password,
        },
      ).timeout(const Duration(seconds: 20));

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(json);
    } on SocketException {
      return const AuthResponse(
        status: false,
        message: 'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException catch (e) {
      return AuthResponse(
        status: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return AuthResponse(
        status: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  /// Register a new user
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
    try {
      final uri = Uri.parse('$baseUrl/register');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Accept'] = 'application/json';

      request.fields['name'] = name.trim();
      request.fields['email'] = email.trim();
      request.fields['field'] = field;
      request.fields['password'] = password;

      if (phone != null && phone.trim().isNotEmpty) {
        request.fields['phone'] = phone.trim();
      }

      // Add resume file if provided (optional)
      if (resumeBytes != null && resumeFileName != null && resumeBytes.isNotEmpty) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'resume',
            resumeBytes,
            filename: resumeFileName,
          ),
        );
      } else if (resumePath != null && resumePath.isNotEmpty) {
        final resumeFile = File(resumePath);
        if (await resumeFile.exists()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'resume',
              resumePath,
            ),
          );
        }
      }

      final streamedResponse = await _client.send(request).timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(json);
    } on SocketException {
      return const AuthResponse(
        status: false,
        message: 'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException catch (e) {
      return AuthResponse(
        status: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return AuthResponse(
        status: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  /// Refresh authentication token
  Future<AuthResponse> refreshToken({required String token}) async {
    try {
      final uri = Uri.parse('$baseUrl/refresh');

      final response = await _client.post(
        uri,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 15));

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthResponse.fromJson(json);
    } on SocketException {
      return const AuthResponse(
        status: false,
        message: 'No internet connection.',
      );
    } on http.ClientException catch (e) {
      return AuthResponse(
        status: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return AuthResponse(
        status: false,
        message: 'Token refresh failed: $e',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
