import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:innovate_connecta_app/core/services/auth_session_service.dart';
import 'package:innovate_connecta_app/core/services/database_service.dart';
import 'package:innovate_connecta_app/core/services/secure_auth_storage.dart';
import 'package:innovate_connecta_app/features/auth/models/auth_token.dart';
import 'package:innovate_connecta_app/features/auth/models/auth_user.dart';
import 'package:innovate_connecta_app/features/auth/repository/auth_repository.dart';
import 'package:innovate_connecta_app/features/auth/views/login_screen.dart';
import 'package:innovate_connecta_app/features/home/views/home_screen.dart';
import 'package:innovate_connecta_app/features/onboarding/views/onboarding_screen.dart';
import 'package:innovate_connecta_app/features/profile/view_models/profile_view_model.dart';
import 'package:innovate_connecta_app/features/splash/views/splash_screen.dart';

void main() {
  setUp(() {
    AuthSessionService.resetInstance();
    SecureAuthStorage.resetInstance();
    DatabaseService.resetInstance();
    ProfileViewModel.reset();
  });

  tearDown(() {
    AuthSessionService.resetInstance();
    SecureAuthStorage.resetInstance();
    DatabaseService.resetInstance();
    ProfileViewModel.reset();
  });

  group('SecureAuthStorage & Encryption Tests', () {
    test('Encrypts, stores, reads, and deletes key-value pairs', () async {
      final storage = SecureAuthStorage(isInMemory: true);

      expect(await storage.read(key: 'secret_token'), isNull);
      await storage.write(key: 'secret_token', value: 'bearer_xyz123');

      expect(await storage.read(key: 'secret_token'), 'bearer_xyz123');
      expect(await storage.containsKey(key: 'secret_token'), isTrue);

      await storage.delete(key: 'secret_token');
      expect(await storage.read(key: 'secret_token'), isNull);
      expect(await storage.containsKey(key: 'secret_token'), isFalse);
    });

    test('Data persists in file-backed storage across new instances', () {
      final tempFile = '${Directory.systemTemp.path}/test_secure_vault_${DateTime.now().millisecondsSinceEpoch}.enc';
      addTearDown(() {
        try {
          final f = File(tempFile);
          if (f.existsSync()) f.deleteSync();
        } catch (_) {}
      });

      final storage1 = SecureAuthStorage(customPath: tempFile);
      storage1.writeSync(key: 'jwt_token', value: 'persisted_jwt_token_999');
      storage1.writeSync(key: 'user_email', value: 'rahul.verma@example.com');

      // Create storage2 referencing the exact same vault file (simulating app restart)
      final storage2 = SecureAuthStorage(customPath: tempFile);
      expect(storage2.readSync('jwt_token'), 'persisted_jwt_token_999');
      expect(storage2.readSync('user_email'), 'rahul.verma@example.com');

      // Verify physical file content is encrypted and not plain text
      final rawFileContent = File(tempFile).readAsStringSync();
      expect(rawFileContent.contains('persisted_jwt_token_999'), isFalse);
    });

    test('deleteAll removes all stored keys', () async {
      final storage = SecureAuthStorage(isInMemory: true);
      await storage.write(key: 'k1', value: 'v1');
      await storage.write(key: 'k2', value: 'v2');

      final allBefore = await storage.readAll();
      expect(allBefore.length, 2);

      await storage.deleteAll();
      final allAfter = await storage.readAll();
      expect(allAfter.isEmpty, isTrue);
    });
  });

  group('AuthSessionService Session Management Tests', () {
    test('saveSession stores token, user, and marks session as valid', () async {
      final storage = SecureAuthStorage(isInMemory: true);
      final db = DatabaseService();
      final service = AuthSessionService(storage: storage, db: db);

      expect(service.hasValidSession(), isFalse);

      const token = AuthToken(
        tokenType: 'Bearer',
        token: 'auth_access_token_123',
        expiresIn: 3600,
      );
      const user = AuthUser(
        id: 42,
        name: 'Priya Sharma',
        email: 'priya.sharma@example.com',
        phone: '+91 98111 22233',
        field: 'College Student',
      );

      await service.saveSession(token: token, user: user);

      expect(service.hasValidSession(), isTrue);
      expect(service.isLoggedIn, isTrue);
      expect(service.token?.token, 'auth_access_token_123');
      expect(service.token?.tokenType, 'Bearer');
      expect(service.user?.email, 'priya.sharma@example.com');
      expect(service.user?.name, 'Priya Sharma');
      expect(service.userEmail, 'priya.sharma@example.com');
      expect(service.isTokenExpired, isFalse);
      expect(db.activeUserEmail, 'priya.sharma@example.com');
    });

    test('Detects expired token when expiry timestamp has elapsed', () async {
      final storage = SecureAuthStorage(isInMemory: true);
      final db = DatabaseService();
      final service = AuthSessionService(storage: storage, db: db);

      const token = AuthToken(
        tokenType: 'Bearer',
        token: 'expired_token',
        expiresIn: -10, // already expired
      );
      const user = AuthUser(
        id: 1,
        name: 'Expired User',
        email: 'expired@example.com',
      );

      await service.saveSession(token: token, user: user);

      // Artificially set expiresAt to the past
      storage.writeSync(
        key: AuthSessionService.keyExpiresAt,
        value: (DateTime.now().millisecondsSinceEpoch - 10000).toString(),
      );

      expect(service.isTokenExpired, isTrue);
      expect(service.hasValidSession(), isFalse);
    });

    test('validateOrRefreshSession refreshes expired token with AuthRepository', () async {
      final storage = SecureAuthStorage(isInMemory: true);
      final db = DatabaseService();

      final mockClient = MockClient((request) async {
        if (request.url.path.endsWith('/refresh')) {
          expect(request.headers['Authorization'], 'Bearer old_token_abc');
          return http.Response(
            jsonEncode({
              'status': true,
              'message': 'Token refreshed successfully',
              'data': {
                'token_type': 'Bearer',
                'token': 'new_refreshed_token_xyz',
                'expires_in': 7200,
                'user': {
                  'id': 10,
                  'name': 'Refreshed User',
                  'email': 'refresh@example.com',
                },
              },
            }),
            200,
          );
        }
        return http.Response(jsonEncode({'status': false}), 400);
      });

      final mockRepo = AuthRepository(client: mockClient);
      final service = AuthSessionService(
        storage: storage,
        db: db,
        authRepository: mockRepo,
      );

      // Save initial session
      await service.saveSession(
        token: const AuthToken(
          tokenType: 'Bearer',
          token: 'old_token_abc',
          expiresIn: 3600,
        ),
        user: const AuthUser(
          id: 10,
          name: 'Refreshed User',
          email: 'refresh@example.com',
        ),
      );

      // Force expiration
      storage.writeSync(
        key: AuthSessionService.keyExpiresAt,
        value: (DateTime.now().millisecondsSinceEpoch - 5000).toString(),
      );
      expect(service.isTokenExpired, isTrue);

      // Validate or refresh should call refresh endpoint and succeed
      final valid = await service.validateOrRefreshSession(authRepository: mockRepo);
      expect(valid, isTrue);
      expect(service.token?.token, 'new_refreshed_token_xyz');
      expect(service.isTokenExpired, isFalse);
    });

    test('clearSession clears all tokens, active user, and invalidates session', () async {
      final storage = SecureAuthStorage(isInMemory: true);
      final db = DatabaseService();
      final service = AuthSessionService(storage: storage, db: db);

      await service.saveSession(
        token: const AuthToken(
          tokenType: 'Bearer',
          token: 'token_to_clear',
          expiresIn: 3600,
        ),
        user: const AuthUser(
          id: 99,
          name: 'Logout User',
          email: 'logout@example.com',
        ),
      );

      expect(service.hasValidSession(), isTrue);
      expect(db.activeUserEmail, 'logout@example.com');

      await service.clearSession();

      expect(service.hasValidSession(), isFalse);
      expect(service.token, isNull);
      expect(service.user, isNull);
      expect(service.userEmail, isNull);
      expect(db.activeUserEmail, isNull);
    });
  });

  group('Splash Screen Auto-Login Navigation Tests', () {
    testWidgets('SplashScreen navigates directly to Dashboard (HomeScreen) when valid session exists',
        (WidgetTester tester) async {
      // 1. Setup persistent session in singleton
      const token = AuthToken(
        tokenType: 'Bearer',
        token: 'persistent_token_123',
        expiresIn: 86400 * 7,
      );
      const user = AuthUser(
        id: 777,
        name: 'Aanya Sen',
        email: 'aanya.sen@example.com',
        phone: '+91 9988776655',
      );

      await AuthSessionService.instance.saveSession(
        token: token,
        user: user,
      );

      // 2. Launch App on SplashScreen
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      expect(find.byType(SplashScreen), findsOneWidget);

      // 3. Fast-forward animation & auto-login check
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pump();

      // 4. Verify user landed on HomeScreen (Dashboard), NOT OnboardingScreen or LoginScreen
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsNothing);
      expect(find.byType(LoginScreen), findsNothing);

      // 5. Verify ProfileViewModel was automatically restored
      expect(ProfileViewModel.instance.profile.name, 'Aanya Sen');
      expect(ProfileViewModel.instance.profile.email, 'aanya.sen@example.com');
    });

    testWidgets('SplashScreen navigates to OnboardingScreen when no session exists',
        (WidgetTester tester) async {
      // Ensure no active session
      await AuthSessionService.instance.clearSession();

      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      // Fast-forward animation
      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pump();

      // Verify navigated to OnboardingScreen
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('Logout clears session, navigates to LoginScreen, and subsequent app reopen requires login',
        (WidgetTester tester) async {
      // 1. User starts logged in
      await AuthSessionService.instance.saveSession(
        token: const AuthToken(
          tokenType: 'Bearer',
          token: 'session_active_token',
          expiresIn: 3600,
        ),
        user: const AuthUser(
          id: 50,
          name: 'Test Logged In User',
          email: 'logged_in@example.com',
        ),
      );
      expect(AuthSessionService.instance.hasValidSession(), isTrue);

      // 2. Perform logout
      await ProfileViewModel.instance.logout();

      // 3. Verify session was completely cleared
      expect(AuthSessionService.instance.hasValidSession(), isFalse);
      expect(AuthSessionService.instance.token, isNull);
      expect(AuthSessionService.instance.user, isNull);
      expect(DatabaseService.instance.activeUserEmail, isNull);

      // 4. Reopen app (simulating restart by pumping SplashScreen again)
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      await tester.pump(const Duration(milliseconds: 3000));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 900));
      await tester.pump();

      // 5. Reopening app MUST require login (lands on OnboardingScreen) and NOT auto-login to HomeScreen
      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });
  });
}
