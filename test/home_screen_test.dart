import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovate_connecta_app/features/home/views/home_screen.dart';
import 'package:innovate_connecta_app/features/home/widgets/home_section_header.dart';
import 'package:innovate_connecta_app/features/services/views/services_screen.dart';
import 'package:innovate_connecta_app/features/services/constants/services_strings.dart';
import 'package:innovate_connecta_app/features/contact/views/contact_screen.dart';
import 'package:innovate_connecta_app/features/sessions/views/all_live_sessions_screen.dart';
import 'package:innovate_connecta_app/features/testimonials/views/testimonials_screen.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('HomeScreen Tests', () {
    testWidgets(
      'renders all sections and displays only 3 cards in Programs section',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
        await tester.pumpAndSettle();

        // Brand Title in RichText
        final brandTitleFinder = find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().toLowerCase().contains(
                'innovate connecta',
              ),
        );
        expect(brandTitleFinder, findsWidgets);

        // Hero Elements
        expect(find.text('MSME REGISTERED ORGANISATION'), findsOneWidget);
        expect(find.text('Where Ambition'), findsOneWidget);
        expect(find.text('Explore Services →'), findsOneWidget);
        expect(find.text('Book Live Session'), findsOneWidget);
        expect(find.text('Contact'), findsOneWidget);

        // Live Sessions Section
        expect(find.text('UPCOMING PROGRAMS'), findsOneWidget);
        expect(find.text('Master on Cloud'), findsOneWidget);

        // Event Gallery Section
        expect(find.text('GALLERY'), findsOneWidget);
        expect(find.text('Hands-on tech bootcamps'), findsOneWidget);

        // Programs & Values & Testimonials headers
        expect(find.text('PROGRAMS'), findsOneWidget);
        expect(find.text('CORE ETHOS'), findsOneWidget);
        expect(find.text('TESTIMONIALS'), findsOneWidget);

        // Verify Programs section displays only first 3 cards on Home page
        expect(find.text(ServicesStrings.careerGuidanceTitle), findsOneWidget);
        expect(find.text(ServicesStrings.upskillingTitle), findsOneWidget);
        expect(find.text(ServicesStrings.workshopsTitle), findsOneWidget);
        expect(find.text(ServicesStrings.internshipTitle), findsNothing);
        expect(find.text(ServicesStrings.resourcesTitle), findsNothing);
      },
    );

    testWidgets(
      'clicking Book Live Session navigates to AllLiveSessionsScreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Book Live Session'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
        expect(find.byType(AllLiveSessionsScreen), findsOneWidget);

        Navigator.of(tester.element(find.byType(AllLiveSessionsScreen))).pop();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 300));
      },
    );

    testWidgets(
      'clicking Programs View All navigates to ServicesScreen showing all services',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
        await tester.pumpAndSettle();

        final programsHeader = find.ancestor(
          of: find.text('PROGRAMS'),
          matching: find.byType(HomeSectionHeader),
        );
        final viewAllButton = find.descendant(
          of: programsHeader,
          matching: find.text('View All →'),
        );

        await tester.tap(viewAllButton);
        await tester.pumpAndSettle();
        expect(find.byType(ServicesScreen), findsOneWidget);
        // In ServicesScreen, all services including the 4th, 5th, 6th are displayed
        expect(find.text(ServicesStrings.internshipTitle), findsOneWidget);
        expect(find.text(ServicesStrings.resourcesTitle), findsOneWidget);
      },
    );

    testWidgets('clicking Explore Services opens ServicesScreen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Explore Services →'));
      await tester.pumpAndSettle();
      expect(find.byType(ServicesScreen), findsOneWidget);
    });

    testWidgets('clicking Contact opens ContactScreen', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Contact'));
      await tester.pumpAndSettle();
      expect(find.byType(ContactScreen), findsOneWidget);
    });

    testWidgets(
      'Testimonials section shows View All button and navigates to TestimonialsScreen',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1080, 2400);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
        await tester.pumpAndSettle();

        final testimonialsHeader = find.ancestor(
          of: find.text('TESTIMONIALS'),
          matching: find.byType(HomeSectionHeader),
        );
        final viewAllButton = find.descendant(
          of: testimonialsHeader,
          matching: find.text('View All →'),
        );
        expect(viewAllButton, findsOneWidget);

        await tester.tap(viewAllButton);
        await tester.pumpAndSettle();
        expect(find.byType(TestimonialsScreen), findsOneWidget);
      },
    );
  });
}
