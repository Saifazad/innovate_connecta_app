import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:innovate_connecta_app/features/onboarding/views/onboarding_screen.dart';

void main() {
  setUp(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('OnboardingScreen Tests', () {
    testWidgets('renders all onboarding elements matching design',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        const MaterialApp(
          home: OnboardingScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Heading: Welcome to
      expect(find.text('Welcome to'), findsOneWidget);

      // InnoVate Connecta brand title
      final brandFinder = find.byWidgetPredicate(
        (w) =>
            w is RichText &&
            w.text.toPlainText().contains('InnoVate Connecta'),
      );
      expect(brandFinder, findsOneWidget);

      // Subtitle
      expect(
        find.textContaining('Empowering enterprises and'),
        findsOneWidget,
      );

      // 3 Feature Pillars
      expect(find.text('Connect'), findsOneWidget);
      expect(find.text('Collaborate'), findsOneWidget);
      expect(find.text('Scale'), findsOneWidget);

      // Action Buttons
      expect(find.text('Get Started'), findsOneWidget);
      expect(find.text('Sign In with Account'), findsOneWidget);
    });
  });
}

