import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../core/services/auth_session_service.dart';
import '../models/live_session_model.dart';
import '../models/recorded_session_model.dart';
import '../models/session_category_model.dart';

class SessionsRepository {
  static const String liveSessionsEndpoint =
      'https://awsdemo.co.in/innovateconnect/api/v1/sessions';
  static const String recordedSessionsEndpoint =
      'https://awsdemo.co.in/innovateconnect/api/v1/recorded-sessions';
  static const String recordedCategoriesEndpoint =
      'https://awsdemo.co.in/innovateconnect/api/v1/session-categories?type=recorded';
  static const String studentRecordedOrdersEndpoint =
      'https://awsdemo.co.in/innovateconnect/api/v1/student/recorded-orders';

  final http.Client _client;

  SessionsRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch live sessions dynamically from backend API
  Future<List<LiveSessionModel>> fetchLiveSessions() async {
    try {
      final response = await _client.get(
        Uri.parse(liveSessionsEndpoint),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final list = (decoded['data'] as List)
              .whereType<Map<String, dynamic>>()
              .where((item) {
                final title = (item['title'] ?? '').toString().toLowerCase().trim();
                return title.isNotEmpty && !title.startsWith('test');
              })
              .map((item) => LiveSessionModel.fromJson(item))
              .toList();

          return list;
        }
      }
      return [];
    } on SocketException {
      throw const SocketException('No internet connection');
    } catch (e) {
      rethrow;
    }
  }

  /// Helper to validate that a recorded session record is not dummy or test
  static bool _isValidRecordedSessionJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? '').toString().toLowerCase().trim();
    if (title.isEmpty || title.startsWith('test') || title.startsWith('dummy')) {
      return false;
    }
    return true;
  }

  /// Fetch recorded sessions dynamically from backend API
  Future<List<RecordedSessionModel>> fetchRecordedSessions() async {
    try {
      final response = await _client.get(
        Uri.parse(recordedSessionsEndpoint),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final rawList = decoded['data'] as List;

          // Filter out dummy, test, and incomplete records
          final validList = rawList
              .whereType<Map<String, dynamic>>()
              .where(_isValidRecordedSessionJson)
              .map((item) => RecordedSessionModel.fromJson(item))
              .toList();

          // If recorded-sessions endpoint has at least 3 valid items, return them directly
          if (validList.length >= 3) {
            return validList;
          }

          // If fewer than 3, dynamically check the sessions API for recorded-type sessions
          try {
            final sessionsResponse = await _client.get(
              Uri.parse(liveSessionsEndpoint),
              headers: {'Accept': 'application/json'},
            ).timeout(const Duration(seconds: 10));

            if (sessionsResponse.statusCode >= 200 && sessionsResponse.statusCode < 300) {
              final sessionsDecoded = jsonDecode(sessionsResponse.body);
              if (sessionsDecoded is Map<String, dynamic> && sessionsDecoded['data'] is List) {
                final existingTitles = validList.map((e) => e.title.toLowerCase().trim()).toSet();
                final existingIds = validList.map((e) => e.id).toSet();

                for (final item in sessionsDecoded['data']) {
                  if (item is Map<String, dynamic>) {
                    final itemTitle = (item['title'] ?? '').toString().toLowerCase().trim();
                    if (itemTitle.isEmpty || itemTitle.startsWith('test')) continue;

                    final catMap = item['category'];
                    final catType = (catMap is Map<String, dynamic> ? catMap['type'] : '').toString().toLowerCase();

                    if ((catType == 'recorded' || catType == 'all') &&
                        !existingTitles.contains(itemTitle) &&
                        !existingIds.contains(item['id'])) {
                      validList.add(RecordedSessionModel.fromSessionJson(item));
                      existingTitles.add(itemTitle);
                      existingIds.add(item['id'] is int ? item['id'] as int : 0);
                    }
                  }
                }
              }
            }
          } catch (_) {
            // Ignore secondary fetch errors and return what we got
          }

          return validList;
        }
      }
      return [];
    } on SocketException {
      throw const SocketException('No internet connection');
    } catch (e) {
      rethrow;
    }
  }

  /// Fetch recorded session categories from the API:
  /// https://awsdemo.co.in/innovateconnect/api/v1/session-categories?type=recorded
  Future<List<SessionCategoryModel>> fetchRecordedCategories() async {
    try {
      final response = await _client.get(
        Uri.parse(recordedCategoriesEndpoint),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final list = (decoded['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((item) => SessionCategoryModel.fromJson(item))
              .where((c) => c.name.trim().isNotEmpty && c.slug != 'test' && !c.name.toLowerCase().startsWith('test'))
              .toList();
          return list;
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  /// Fetch a single recorded session by slug or ID with user credentials:
  /// https://awsdemo.co.in/innovateconnect/api/v1/recorded-sessions/{slug}?email={email}&user_id={user_id}
  Future<RecordedSessionModel?> fetchRecordedSessionDetails({
    String? slug,
    int? id,
    String? email,
    int? userId,
  }) async {
    try {
      final currentUser = AuthSessionService.instance.user;
      final currentToken = AuthSessionService.instance.token;

      final finalEmail = (email != null && email.trim().isNotEmpty)
          ? email.trim()
          : (currentUser != null && currentUser.email.trim().isNotEmpty)
              ? currentUser.email.trim()
              : 'apitest@gmail.com';

      final finalUserId = (userId != null && userId > 0)
          ? userId
          : (currentUser != null && currentUser.id > 0)
              ? currentUser.id
              : 7;

      final identifier = (slug != null && slug.trim().isNotEmpty)
          ? slug.trim()
          : (id != null && id > 0)
              ? '$id'
              : '';

      if (identifier.isEmpty) return null;

      final uri = Uri.parse('$recordedSessionsEndpoint/$identifier').replace(
        queryParameters: {
          'email': finalEmail,
          'user_id': '$finalUserId',
        },
      );

      final headers = <String, String>{
        'Accept': 'application/json',
      };
      if (currentToken != null && currentToken.token.isNotEmpty) {
        headers['Authorization'] = '${currentToken.tokenType} ${currentToken.token}';
      }

      final response = await _client.get(
        uri,
        headers: headers,
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        Map<String, dynamic>? itemData;
        if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is Map<String, dynamic>) {
            itemData = decoded['data'] as Map<String, dynamic>;
          } else if (decoded.containsKey('title') || decoded.containsKey('id')) {
            itemData = decoded;
          }
        }
        if (itemData != null) {
          return RecordedSessionModel.fromJson(itemData);
        }
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Backward-compatible fetch by ID (delegates to fetchRecordedSessionDetails)
  Future<RecordedSessionModel?> fetchRecordedSessionById(
    int id, {
    String? slug,
    String? email,
    int? userId,
  }) async {
    return fetchRecordedSessionDetails(
      slug: slug,
      id: id,
      email: email,
      userId: userId,
    );
  }

  /// Fetch user purchased courses / recorded sessions from student orders API:
  /// https://awsdemo.co.in/innovateconnect/api/v1/student/recorded-orders?email={email}&user_id={user_id}
  Future<List<RecordedSessionModel>> fetchStudentRecordedOrders({
    String? email,
    int? userId,
  }) async {
    try {
      final currentUser = AuthSessionService.instance.user;
      final currentToken = AuthSessionService.instance.token;

      final finalEmail = (email != null && email.trim().isNotEmpty)
          ? email.trim()
          : (currentUser != null && currentUser.email.trim().isNotEmpty)
              ? currentUser.email.trim()
              : (AuthSessionService.instance.userEmail ?? '');

      final finalUserId = (userId != null && userId > 0)
          ? userId
          : (currentUser != null && currentUser.id > 0)
              ? currentUser.id
              : 0;

      if (finalEmail.isEmpty && finalUserId <= 0) {
        return [];
      }

      final queryParams = <String, String>{};
      if (finalEmail.isNotEmpty) {
        queryParams['email'] = finalEmail;
      }
      if (finalUserId > 0) {
        queryParams['user_id'] = '$finalUserId';
      }

      final uri = Uri.parse(studentRecordedOrdersEndpoint)
          .replace(queryParameters: queryParams);

      final headers = <String, String>{
        'Accept': 'application/json',
      };
      if (currentToken != null && currentToken.token.isNotEmpty) {
        headers['Authorization'] =
            '${currentToken.tokenType} ${currentToken.token}';
      }

      final response = await _client.get(uri, headers: headers).timeout(
            const Duration(seconds: 15),
          );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic> && decoded['data'] is List) {
          final List<RecordedSessionModel> list = [];
          for (final order in decoded['data']) {
            if (order is Map<String, dynamic>) {
              final paymentStatus =
                  (order['payment_status'] ?? '').toString().toLowerCase();
              if (paymentStatus.isNotEmpty &&
                  paymentStatus != 'completed' &&
                  paymentStatus != 'success' &&
                  paymentStatus != 'paid') {
                continue;
              }

              if (order['recorded_session'] is Map<String, dynamic>) {
                final sessionMap =
                    order['recorded_session'] as Map<String, dynamic>;
                list.add(
                  RecordedSessionModel.fromJson(sessionMap)
                      .copyWith(isEnrolled: true),
                );
              } else {
                list.add(
                  RecordedSessionModel(
                    id: order['recorded_session_id'] is int
                        ? order['recorded_session_id'] as int
                        : (order['id'] is int ? order['id'] as int : 0),
                    title: (order['session_title'] ?? 'Recorded Masterclass')
                        .toString(),
                    categoryName: 'Recorded Session',
                    duration: '14 Hours',
                    lessons: '18 Lessons',
                    discountPrice: (order['formatted_amount'] ??
                            order['amount'] ??
                            '₹3,999')
                        .toString(),
                    originalPrice: (order['formatted_original_price'] ??
                            order['original_price'] ??
                            '₹4,999')
                        .toString(),
                    isEnrolled: true,
                  ),
                );
              }
            }
          }
          return list;
        }
      }
      return [];
    } catch (_) {
      return [];
    }
  }

  void dispose() {
    _client.close();
  }
}
