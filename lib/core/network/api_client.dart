import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../services/auth_session_service.dart';
import 'network_exceptions.dart';

/// Configured base HTTP client wrapper with automatic token management,
/// timeout handling, and typed NetworkException translation.
class ApiClient {
  final http.Client _client;
  final Duration defaultTimeout;

  ApiClient({
    http.Client? client,
    this.defaultTimeout = const Duration(seconds: 15),
  }) : _client = client ?? http.Client();

  /// Builds standardized request headers including Bearer token if available
  Map<String, String> _buildHeaders({
    Map<String, String>? extraHeaders,
    bool includeAuth = true,
    bool isJson = true,
  }) {
    final headers = <String, String>{
      'Accept': 'application/json',
    };

    if (isJson) {
      headers['Content-Type'] = 'application/json';
    }

    if (includeAuth) {
      final authToken = AuthSessionService.instance.token?.token;
      if (authToken != null && authToken.isNotEmpty) {
        headers['Authorization'] = 'Bearer $authToken';
      }
    }

    if (extraHeaders != null) {
      headers.addAll(extraHeaders);
    }

    return headers;
  }

  /// Executes an HTTP GET request
  Future<dynamic> get(
    String url, {
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    return _sendRequest(() {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, includeAuth: includeAuth);
      return _client.get(uri, headers: finalHeaders).timeout(defaultTimeout);
    });
  }

  /// Executes an HTTP POST request
  Future<dynamic> post(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    return _sendRequest(() {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, includeAuth: includeAuth);
      final encodedBody = body is Map || body is List ? jsonEncode(body) : body;
      return _client.post(uri, headers: finalHeaders, body: encodedBody).timeout(defaultTimeout);
    });
  }

  /// Executes an HTTP PUT request
  Future<dynamic> put(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    return _sendRequest(() {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, includeAuth: includeAuth);
      final encodedBody = body is Map || body is List ? jsonEncode(body) : body;
      return _client.put(uri, headers: finalHeaders, body: encodedBody).timeout(defaultTimeout);
    });
  }

  /// Executes an HTTP DELETE request
  Future<dynamic> delete(
    String url, {
    dynamic body,
    Map<String, String>? headers,
    bool includeAuth = true,
  }) async {
    return _sendRequest(() {
      final uri = Uri.parse(url);
      final finalHeaders = _buildHeaders(extraHeaders: headers, includeAuth: includeAuth);
      final encodedBody = body is Map || body is List ? jsonEncode(body) : body;
      return _client.delete(uri, headers: finalHeaders, body: encodedBody).timeout(defaultTimeout);
    });
  }

  /// Executes a Multipart Request (for file/photo uploads)
  Future<dynamic> sendMultipart(http.MultipartRequest request) async {
    try {
      final authToken = AuthSessionService.instance.token?.token;
      if (authToken != null && authToken.isNotEmpty && !request.headers.containsKey('Authorization')) {
        request.headers['Authorization'] = 'Bearer $authToken';
      }
      request.headers['Accept'] = 'application/json';

      final streamedResponse = await _client.send(request).timeout(defaultTimeout);
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse(response);
    } on SocketException catch (_) {
      throw const NoInternetException();
    } on TimeoutException catch (_) {
      throw const ApiTimeoutException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.fromException(e);
    }
  }

  /// Internal request wrapper with unified error handling
  Future<dynamic> _sendRequest(Future<http.Response> Function() requestAction) async {
    try {
      final response = await requestAction();
      return _handleResponse(response);
    } on SocketException catch (_) {
      throw const NoInternetException();
    } on TimeoutException catch (_) {
      throw const ApiTimeoutException();
    } catch (e) {
      if (e is NetworkException) rethrow;
      throw NetworkException.fromException(e);
    }
  }

  /// Validates status codes and decodes JSON bodies
  dynamic _handleResponse(http.Response response) {
    dynamic decoded;
    if (response.body.isNotEmpty) {
      try {
        decoded = jsonDecode(response.body);
      } catch (_) {
        decoded = response.body;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return decoded;
    }

    String message = 'Request failed with status code ${response.statusCode}';
    if (decoded is Map && decoded['message'] != null) {
      message = decoded['message'].toString();
    } else if (decoded is Map && decoded['error'] != null) {
      message = decoded['error'].toString();
    }

    throw NetworkException.fromStatusCode(
      response.statusCode,
      message: message,
      details: decoded,
    );
  }

  /// Clean disposal
  void close() {
    _client.close();
  }
}

