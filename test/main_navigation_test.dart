import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovate_connecta_app/shared/widgets/app_bottom_nav_bar.dart';
import 'package:innovate_connecta_app/app/main_navigation_screen.dart';
import 'package:innovate_connecta_app/app/routes/app_routes.dart';
import 'package:innovate_connecta_app/features/about/views/our_values_screen.dart';
import 'package:innovate_connecta_app/features/services/views/services_screen.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('MainNavigationScreen & Persistent Footer Tests', () {
    testWidgets('renders all 5 tabs and footer stays persistent on tab tap',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigationScreen(initialIndex: 0),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify AppBottomNavBar is present (exactly one)
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Sessions'), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Resources'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      // 2. Initial state is Home (index 0)
      expect(find.text('Where Ambition'), findsOneWidget);

      // 3. Tap "Sessions"
      await tester.tap(find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Sessions'),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Exactly one footer stays persistent
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      expect(find.text('Masterclasses, live workshops & recordings'), findsOneWidget);

      // 4. Tap "Dashboard" (Center Icon)
      await tester.tap(find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Dashboard'),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Footer is STILL present without being unmounted
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      // Dashboard screen title is visible
      expect(find.text('My Dashboard'), findsOneWidget);

      // 5. Tap "Resources"
      await tester.tap(find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Resources'),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Footer is STILL present
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      // Resources screen is visible
      expect(find.text('8 Files'), findsOneWidget);

      // 6. Tap "Home" again
      await tester.tap(find.descendant(
        of: find.byType(AppBottomNavBar),
        matching: find.text('Home'),
      ));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Returned to Home cleanly
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      expect(find.text('Where Ambition'), findsOneWidget);
    });

    testWidgets('back navigation returns to Home tab without unmounting navbar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: MainNavigationScreen(initialIndex: 2), // Starts on Dashboard
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(AppBottomNavBar), findsOneWidget);
      expect(find.text('My Dashboard'), findsOneWidget);

      // Simulate back button via PopScope
      final dynamic popScope = tester.state(find.byType(MainNavigationScreen));
      popScope.setIndex(0);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Back on Home tab, single navbar preserved
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      expect(find.text('Where Ambition'), findsOneWidget);
    });

    testWidgets('OurValuesScreen does not show duplicate or incorrect bottom navbar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: OurValuesScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Ensure NO bottom navbar is rendered in OurValuesScreen
      expect(find.byType(AppBottomNavBar), findsNothing);
      expect(
        find.byWidgetPredicate(
          (w) => w is RichText && w.text.toPlainText().contains('Our Values'),
        ),
        findsOneWidget,
      );
      expect(find.text('ABOUT ORGANIZATION'), findsOneWidget);
    });

    testWidgets('ServicesScreen has zero bottom navbars',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: ServicesScreen(),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.byType(AppBottomNavBar), findsNothing);
    });

    testWidgets('AppRoutes maps tab destinations to MainNavigationScreen with single navbar',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: AppRoutes.sessions,
          onGenerateRoute: AppRoutes.onGenerateRoute,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Exactly ONE AppBottomNavBar
      expect(find.byType(AppBottomNavBar), findsOneWidget);
      // Pushed route lands directly in Sessions tab inside MainNavigationScreen
      expect(find.text('Masterclasses, live workshops & recordings'), findsOneWidget);
    });
  });
}

