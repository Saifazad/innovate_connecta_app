import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:innovate_connecta_app/features/splash/views/splash_screen.dart';
import 'package:innovate_connecta_app/features/onboarding/views/onboarding_screen.dart';
import 'package:innovate_connecta_app/features/auth/views/login_screen.dart';
import 'package:innovate_connecta_app/features/auth/views/register_screen.dart';

void main() {
  testWidgets('Full flow: Splash -> Onboarding -> Login -> Register -> Login',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashScreen(),
      ),
    );

    // Initial splash elements
    expect(find.byType(SplashScreen), findsOneWidget);

    // Pump through intro animation (3000ms) + delay (600ms) + route mount & transition (500ms)
    await tester.pump(const Duration(milliseconds: 3000));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump();

    // Verify OnboardingScreen is shown
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Welcome to InnoVate'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.text('Sign In with Account'), findsOneWidget);

    // Tap Get Started button and verify navigation to LoginScreen
    await tester.tap(find.text('Get Started'));
    await tester.pump(); // mounts the new route
    await tester.pump(const Duration(milliseconds: 400)); // completes route transition
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.text('Please log in to continue'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('OR CONNECT WITH'), findsOneWidget);

    // In LoginScreen, if user is not registered, tap Register link to navigate to RegisterScreen
    final registerLinkFinder = find.byWidgetPredicate(
      (widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains("Don't have an account? Register"),
    );
    expect(registerLinkFinder, findsOneWidget);
    await tester.ensureVisible(registerLinkFinder);
    await tester.pump();
    await tester.tap(registerLinkFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(RegisterScreen), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Join our professional community'), findsOneWidget);
    expect(find.text('College Student'), findsWidgets);
    expect(find.text('Create Free Account'), findsOneWidget);

    // In RegisterScreen, tap Login link to return to LoginScreen
    final loginLinkFinder = find.byWidgetPredicate(
      (widget) =>
          widget is RichText &&
          widget.text.toPlainText().contains('Already have an account? Login'),
    );
    expect(loginLinkFinder, findsOneWidget);
    await tester.ensureVisible(loginLinkFinder);
    await tester.pump();
    await tester.tap(loginLinkFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(LoginScreen), findsOneWidget);
  });
}
