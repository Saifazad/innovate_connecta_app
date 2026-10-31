import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:innovate_connecta_app/core/services/purchased_sessions_service.dart';
import 'package:innovate_connecta_app/features/profile/models/certificate_model.dart';
import 'package:innovate_connecta_app/features/profile/repository/certificates_repository.dart';
import 'package:innovate_connecta_app/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:innovate_connecta_app/features/dashboard/views/dashboard_screen.dart';
import 'package:innovate_connecta_app/features/sessions/models/recorded_session_model.dart';
import 'package:innovate_connecta_app/features/sessions/repository/sessions_repository.dart';
import 'package:innovate_connecta_app/features/sessions/views/all_purchased_recorded_sessions_screen.dart';
import 'package:innovate_connecta_app/features/sessions/widgets/purchased_recorded_session_card.dart';

class FakeCertificatesRepository extends CertificatesRepository {
  @override
  Future<List<CertificateModel>> fetchCertificates() async =>
      CertificateModel.dummyCertificates;
}

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    PurchasedSessionsService.instance.clearPurchases();
  });

  tearDown(() {
    PurchasedSessionsService.instance.clearPurchases();
  });

  final testSession = RecordedSessionModel(
    id: 101,
    title: 'System Design & Scalable Architecture',
    slug: 'system-design-scalable-architecture',
    categoryName: 'System Design',
    heading: 'Learn to design scalable, reliable and production-ready software systems.',
    duration: '14 Hours',
    lessons: '18 Lessons',
    discountPrice: '₹3,999',
    originalPrice: '₹4,999',
    isEnrolled: true,
  );

  group('PurchasedSessionsService Tests', () {
    test('initial state has no purchases', () {
      final service = PurchasedSessionsService.instance;
      expect(service.getPurchasedSessions().isEmpty, isTrue);
      expect(service.isPurchased('system-design-scalable-architecture'), isFalse);
    });

    test('recordPurchase saves session with enrolled status', () async {
      final service = PurchasedSessionsService.instance;
      await service.recordPurchase(
        session: testSession,
        studentName: 'Adil',
        studentEmail: 'adil@test.com',
        totalPaid: '₹3,999',
      );

      final list = service.getPurchasedSessions(email: 'adil@test.com');
      expect(list.length, equals(1));
      expect(list.first.title, equals('System Design & Scalable Architecture'));
      expect(list.first.isEnrolled, isTrue);
      expect(service.isPurchased('system-design-scalable-architecture'), isTrue);
    });
  });

  group('PurchasedRecordedSessionCard Widget Tests', () {
    testWidgets('renders all visual elements matching Figma screenshot',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PurchasedRecordedSessionCard(
              session: testSession,
              orientation: Axis.vertical,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Top Left Green Badge: Lifetime Access
      expect(find.text('Lifetime Access'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);

      // Bottom Right Pill: 14 Hours • 18 Lessons
      expect(find.textContaining('14 Hours • 18 Lessons'), findsOneWidget);

      // Category badge
      expect(find.text('System Design'), findsOneWidget);

      // Title & Heading / Subtitle
      expect(find.text('System Design & Scalable Architecture'), findsOneWidget);
      expect(
        find.text(
          'Learn to design scalable, reliable and production-ready software systems.',
        ),
        findsOneWidget,
      );

      // Bottom Row: Unlocked & Watch Now ->
      expect(find.text('Unlocked'), findsOneWidget);
      expect(find.byIcon(Icons.lock_open_rounded), findsOneWidget);
      expect(find.text('Watch Now'), findsOneWidget);
      expect(find.text('→'), findsOneWidget);
    });
  });

  group('AllPurchasedRecordedSessionsScreen Widget Tests', () {
    testWidgets('shows empty state when no sessions are purchased',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AllPurchasedRecordedSessionsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('All Purchased Recorded Sessions'), findsOneWidget);
      expect(find.text('No Purchased Recorded Sessions Yet'), findsOneWidget);
      expect(find.text('Explore Masterclasses'), findsOneWidget);
      expect(find.byType(PurchasedRecordedSessionCard), findsNothing);
    });

    testWidgets('shows purchased cards when sessions are bought',
        (WidgetTester tester) async {
      await PurchasedSessionsService.instance.recordPurchase(session: testSession);

      await tester.pumpWidget(
        const MaterialApp(
          home: AllPurchasedRecordedSessionsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('All Purchased Recorded Sessions'), findsOneWidget);
      expect(find.byType(PurchasedRecordedSessionCard), findsOneWidget);
      expect(find.text('Watch Now'), findsOneWidget);
    });
  });

  group('DashboardScreen Purchased Section Tests', () {
    testWidgets('shows empty state card when user has not purchased',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      final mockRepo = SessionsRepository(
        client: MockClient((request) async {
          return http.Response(jsonEncode({'status': true, 'data': []}), 200);
        }),
      );
      final vm = DashboardViewModel(
        sessionsRepository: mockRepo,
        certificatesRepository: FakeCertificatesRepository(),
      );
      await vm.loadDashboardData();

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(viewModel: vm),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Purchased Recorded Sessions'), findsOneWidget);
      expect(find.text('No Purchased Recorded Sessions Yet'), findsOneWidget);
      expect(find.text('Explore Masterclasses'), findsOneWidget);
      expect(find.byType(PurchasedRecordedSessionCard), findsNothing);
    });

    testWidgets('shows max 3 purchased cards after payment',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Record 4 purchases
      for (int i = 1; i <= 4; i++) {
        await PurchasedSessionsService.instance.recordPurchase(
          session: testSession.copyWith(
            id: 200 + i,
            slug: 'course-slug-$i',
            title: 'Course $i',
          ),
        );
      }

      final mockRepo = SessionsRepository(
        client: MockClient((request) async {
          return http.Response(jsonEncode({'status': true, 'data': []}), 200);
        }),
      );
      final vm = DashboardViewModel(
        sessionsRepository: mockRepo,
        certificatesRepository: FakeCertificatesRepository(),
      );
      await vm.loadDashboardData();

      await tester.pumpWidget(
        MaterialApp(
          home: DashboardScreen(viewModel: vm),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Purchased Recorded Sessions'), findsOneWidget);
      expect(find.text('No Purchased Recorded Sessions Yet'), findsNothing);
      expect(find.textContaining('View All (4)'), findsOneWidget);

      // Verify at most 3 cards are displayed in dashboard
      expect(find.byType(PurchasedRecordedSessionCard), findsNWidgets(3));
    });
  });
}

