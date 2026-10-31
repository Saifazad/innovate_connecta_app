import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovate_connecta_app/core/services/purchased_sessions_service.dart';
import 'package:innovate_connecta_app/features/resources/views/resources_screen.dart';
import 'package:innovate_connecta_app/features/resources/models/resource_item_model.dart';
import 'package:innovate_connecta_app/features/sessions/models/recorded_session_model.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
    PurchasedSessionsService.instance.clearPurchases();
  });

  tearDown(() {
    PurchasedSessionsService.instance.clearPurchases();
  });

  final testSession = RecordedSessionModel(
    id: 991,
    title: 'IPR & Patent Filing Essentials',
    slug: 'ipr-patent-filing-essentials',
    categoryName: 'Legal & Tech',
    heading: 'Master patent law, IP protection, and filing workflows.',
    duration: '14 Hours',
    lessons: '18 Lessons',
    discountPrice: '₹3,999',
    originalPrice: '₹4,999',
    isEnrolled: true,
  );

  group('ResourcesScreen Tests', () {
    test('ResourceItemModel has 8 default files', () {
      expect(ResourceItemModel.defaultResources.length, equals(8));
    });

    testWidgets('shows empty state when user has not made any payment',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: ResourcesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar & header
      expect(find.text('Innovate Connecta'), findsOneWidget);
      expect(find.text('Session PDF Resources'), findsOneWidget);
      expect(
        find.text('View and download PDF notes for your enrolled masterclasses.'),
        findsOneWidget,
      );

      // Empty state
      expect(find.text('No PDF Resources Unlocked Yet'), findsOneWidget);
      expect(find.text('Explore Masterclasses'), findsOneWidget);
      expect(find.text('PDF Guide'), findsNothing);
    });

    testWidgets('shows PDF card only for the session that was paid for',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      // Record payment for test session
      await PurchasedSessionsService.instance.recordPurchase(session: testSession);

      await tester.pumpWidget(
        const MaterialApp(
          home: ResourcesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Top bar & header
      expect(find.text('Session PDF Resources'), findsOneWidget);
      expect(find.text('No PDF Resources Unlocked Yet'), findsNothing);

      // Verified session PDF card matching uploaded image
      expect(find.text('IPR & Patent Filing Essentials'), findsOneWidget);
      expect(find.text('18 Pages'), findsOneWidget);
      expect(find.text('4.2 MB'), findsOneWidget);
      expect(find.text('PDF Guide'), findsOneWidget);
      expect(find.text('PDF'), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Test PDF preview dialog
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pumpAndSettle();

      expect(find.text('PDF Notes Preview'), findsOneWidget);
      expect(find.text('Download PDF'), findsOneWidget);

      // Close preview dialog
      await tester.tap(find.text('Close'));
      await tester.pumpAndSettle();
    });

    testWidgets('no overflow on narrow mobile screen (360px width)',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await PurchasedSessionsService.instance.recordPurchase(session: testSession);

      await tester.pumpWidget(
        const MaterialApp(
          home: ResourcesScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Ensure no RenderFlex overflow exceptions were thrown
      expect(tester.takeException(), isNull);
      expect(find.text('PDF Guide'), findsOneWidget);
    });
  });
}
