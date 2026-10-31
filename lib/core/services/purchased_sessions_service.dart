import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../features/sessions/models/recorded_session_model.dart';
import '../../features/sessions/repository/sessions_repository.dart';
import 'auth_session_service.dart';

/// Persistent service that manages recorded sessions purchased by users after payment.
class PurchasedSessionsService {
  static PurchasedSessionsService? _instance;
  static PurchasedSessionsService get instance =>
      _instance ??= PurchasedSessionsService._fileBased(
        '${Directory.systemTemp.path}/innovate_connecta_purchased_sessions.json',
      );

  final Map<String, List<Map<String, dynamic>>> _purchasesByUser = {};
  File? _dbFile;
  bool _initialized = false;
  final ValueNotifier<int> purchaseCountNotifier = ValueNotifier<int>(0);

  /// Isolated constructor for tests or custom paths
  PurchasedSessionsService({String? customPath}) {
    if (customPath != null) {
      _dbFile = File(customPath);
    }
  }

  PurchasedSessionsService._fileBased(String path) : _dbFile = File(path);

  void init() {
    if (_initialized) return;
    try {
      if (_dbFile != null && _dbFile!.existsSync()) {
        final content = _dbFile!.readAsStringSync();
        if (content.trim().isNotEmpty) {
          final decoded = jsonDecode(content);
          if (decoded is Map<String, dynamic>) {
            decoded.forEach((key, val) {
              if (val is List) {
                _purchasesByUser[key.toLowerCase()] =
                    val.whereType<Map<String, dynamic>>().toList();
              }
            });
          }
        }
      }
    } catch (_) {
      // Graceful fallback to memory
    }
    _initialized = true;
    _updateNotifier();
  }

  String _resolveUserKey([String? email]) {
    if (email != null && email.trim().isNotEmpty) {
      return email.trim().toLowerCase();
    }
    final authUser = AuthSessionService.instance.user;
    if (authUser != null && authUser.email.trim().isNotEmpty) {
      return authUser.email.trim().toLowerCase();
    }
    return 'default_active_user';
  }

  void _updateNotifier() {
    final list = getPurchasedSessions();
    purchaseCountNotifier.value = list.length;
  }

  void _persist() {
    try {
      if (_dbFile != null) {
        if (!_dbFile!.existsSync()) {
          _dbFile!.createSync(recursive: true);
        }
        _dbFile!.writeAsStringSync(jsonEncode(_purchasesByUser));
      }
    } catch (_) {
      // In-memory fallback
    }
    _updateNotifier();
  }

  /// Sync user purchases from backend API:
  /// https://awsdemo.co.in/innovateconnect/api/v1/student/recorded-orders?email={email}&user_id={user_id}
  Future<List<RecordedSessionModel>> syncFromApi({
    String? email,
    int? userId,
    SessionsRepository? repository,
  }) async {
    init();
    final repo = repository ?? SessionsRepository();

    final user = AuthSessionService.instance.user;
    final effectiveEmail = (email != null && email.trim().isNotEmpty)
        ? email.trim()
        : (user?.email ?? AuthSessionService.instance.userEmail);
    final effectiveUserId = (userId != null && userId > 0)
        ? userId
        : (user?.id ?? 0);

    if (effectiveEmail == null || effectiveEmail.trim().isEmpty) {
      return getPurchasedSessions(email: email);
    }

    try {
      final apiOrders = await repo.fetchStudentRecordedOrders(
        email: effectiveEmail,
        userId: effectiveUserId,
      );

      final key = effectiveEmail.trim().toLowerCase();
      final localExisting = _purchasesByUser[key] ?? [];

      // Merge local purchases and API orders without losing any purchase
      final mergedList = <Map<String, dynamic>>[];
      final seenIds = <int>{};
      final seenSlugs = <String>{};

      // 1. Keep local purchases first
      for (final map in localExisting) {
        final id = map['id'] is int
            ? map['id'] as int
            : int.tryParse('${map['id']}') ?? 0;
        final slug = (map['slug'] ?? '').toString().toLowerCase().trim();
        if (id > 0) seenIds.add(id);
        if (slug.isNotEmpty) seenSlugs.add(slug);
        mergedList.add(map);
      }

      // 2. Add API orders that aren't already recorded
      for (final orderSession in apiOrders) {
        final id = orderSession.id;
        final slug = (orderSession.slug ?? '').toLowerCase().trim();
        if (id > 0 && seenIds.contains(id)) continue;
        if (slug.isNotEmpty && seenSlugs.contains(slug)) continue;

        if (id > 0) seenIds.add(id);
        if (slug.isNotEmpty) seenSlugs.add(slug);
        mergedList.add(orderSession.copyWith(isEnrolled: true).toJson());
      }

      _purchasesByUser[key] = mergedList;

      // Also mirror to default_active_user so shared/fallback views also see it
      final defaultList = _purchasesByUser['default_active_user'] ?? [];
      for (final map in mergedList) {
        final id = map['id'] is int
            ? map['id'] as int
            : int.tryParse('${map['id']}') ?? 0;
        final slug = (map['slug'] ?? '').toString().toLowerCase().trim();
        defaultList.removeWhere((item) {
          final itemId = item['id'] is int
              ? item['id'] as int
              : int.tryParse('${item['id']}') ?? 0;
          final itemSlug =
              (item['slug'] ?? '').toString().toLowerCase().trim();
          return (id > 0 && itemId == id) ||
              (slug.isNotEmpty && itemSlug == slug);
        });
        defaultList.insert(0, map);
      }
      _purchasesByUser['default_active_user'] = defaultList;

      _persist();
      return getPurchasedSessions(email: effectiveEmail);
    } catch (_) {
      return getPurchasedSessions(email: effectiveEmail);
    }
  }

  /// Get list of recorded sessions purchased by current/specified user
  List<RecordedSessionModel> getPurchasedSessions({String? email}) {
    init();
    final key = _resolveUserKey(email);
    final rawList = _purchasesByUser[key] ?? [];

    // Fallback to default_active_user if user-specific list is empty
    final effectiveList = (rawList.isEmpty && key != 'default_active_user')
        ? (_purchasesByUser['default_active_user'] ?? [])
        : rawList;

    final result = <RecordedSessionModel>[];
    final seenIds = <int>{};
    final seenSlugs = <String>{};

    for (final map in effectiveList) {
      final session =
          RecordedSessionModel.fromJson(map).copyWith(isEnrolled: true);
      if (session.id > 0 && seenIds.contains(session.id)) {
        continue;
      }
      if (session.slug != null &&
          session.slug!.isNotEmpty &&
          seenSlugs.contains(session.slug)) {
        continue;
      }

      if (session.id > 0) seenIds.add(session.id);
      if (session.slug != null && session.slug!.isNotEmpty) {
        seenSlugs.add(session.slug!);
      }
      result.add(session);
    }

    return result;
  }

  /// Record a new successful purchase for a recorded session
  Future<void> recordPurchase({
    required RecordedSessionModel session,
    String? studentName,
    String? studentEmail,
    String? studentPhone,
    String? bankName,
    String? totalPaid,
    String? orderId,
    String? transactionId,
  }) async {
    init();
    final key = _resolveUserKey(studentEmail);

    final enrolledSession = session.copyWith(isEnrolled: true);
    final map = enrolledSession.toJson();

    map['student_name'] = studentName;
    map['student_email'] = studentEmail;
    map['student_phone'] = studentPhone;
    map['bank_name'] = bankName;
    map['total_paid'] = totalPaid;
    map['order_id'] = orderId;
    map['transaction_id'] = transactionId;
    map['purchased_at'] = DateTime.now().toIso8601String();
    map['is_enrolled'] = true;

    final userPurchases = _purchasesByUser.putIfAbsent(key, () => []);

    // Remove old entry with same id/slug if exists to update
    userPurchases.removeWhere((item) {
      final idMatch = item['id'] != null && item['id'] == enrolledSession.id;
      final slugMatch = item['slug'] != null &&
          enrolledSession.slug != null &&
          item['slug'] == enrolledSession.slug;
      return idMatch || slugMatch;
    });

    // Add latest purchase to the beginning of the list
    userPurchases.insert(0, map);

    // Also mirror to default_active_user so session remains accessible across user states
    if (key != 'default_active_user') {
      final defaultPurchases = _purchasesByUser.putIfAbsent('default_active_user', () => []);
      defaultPurchases.removeWhere((item) {
        final idMatch = item['id'] != null && item['id'] == enrolledSession.id;
        final slugMatch = item['slug'] != null &&
            enrolledSession.slug != null &&
            item['slug'] == enrolledSession.slug;
        return idMatch || slugMatch;
      });
      defaultPurchases.insert(0, map);
    }

    _persist();
  }

  /// Check if a session has been purchased
  bool isPurchased(String slugOrId, {String? email}) {
    final list = getPurchasedSessions(email: email);
    final query = slugOrId.trim().toLowerCase();
    return list.any((s) =>
        s.id.toString() == query ||
        (s.slug != null && s.slug!.toLowerCase() == query));
  }

  /// Reset/clear purchases (used in tests)
  void clearPurchases() {
    _purchasesByUser.clear();
    _persist();
  }
}

