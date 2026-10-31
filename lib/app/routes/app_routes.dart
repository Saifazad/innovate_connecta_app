import 'package:flutter/material.dart';
import '../main_navigation_screen.dart';
import '../../features/splash/views/splash_screen.dart';
import '../../features/onboarding/views/onboarding_screen.dart';
import '../../features/auth/views/login_screen.dart';
import '../../features/auth/views/register_screen.dart';
import '../../features/auth/views/forgot_password_screen.dart';
import '../../features/sessions/views/all_live_sessions_screen.dart';
import '../../features/sessions/views/recorded_sessions_screen.dart';
import '../../features/profile/views/certificates_screen.dart';
import '../../features/profile/views/resume_screen.dart';
import '../../features/profile/views/feedback_screen.dart';
import '../../features/profile/views/security_screen.dart';
import '../../features/gallery/views/gallery_screen.dart';
import '../../features/contact/views/contact_screen.dart';
import '../../features/services/views/services_screen.dart';
import '../../features/about/views/about_screen.dart';

/// Centralized route definitions and generator for InnoVate Connecta.
class AppRoutes {
  AppRoutes._();

  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String home = '/home';
  static const String sessions = '/sessions';
  static const String allLiveSessions = '/sessions/live';
  static const String recordedSessions = '/sessions/recorded';
  static const String dashboard = '/dashboard';
  static const String resources = '/resources';
  static const String profile = '/profile';
  static const String certificates = '/profile/certificates';
  static const String resume = '/profile/resume';
  static const String feedback = '/profile/feedback';
  static const String security = '/profile/security';
  static const String gallery = '/gallery';
  static const String contact = '/contact';
  static const String services = '/services';
  static const String about = '/about';

  /// Standard Route Generator mapping
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen(), settings: settings);
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen(), settings: settings);
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen(), settings: settings);
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen(), settings: settings);
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen(), settings: settings);
      case main:
        final initialIndex = settings.arguments is int ? settings.arguments as int : 0;
        return MaterialPageRoute(
          builder: (_) => MainNavigationScreen(initialIndex: initialIndex),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(initialIndex: 0),
          settings: settings,
        );
      case sessions:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(initialIndex: 1),
          settings: settings,
        );
      case allLiveSessions:
        return MaterialPageRoute(builder: (_) => const AllLiveSessionsScreen(), settings: settings);
      case recordedSessions:
        return MaterialPageRoute(builder: (_) => const RecordedSessionsScreen(), settings: settings);
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(initialIndex: 2),
          settings: settings,
        );
      case resources:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(initialIndex: 3),
          settings: settings,
        );
      case profile:
        return MaterialPageRoute(
          builder: (_) => const MainNavigationScreen(initialIndex: 4),
          settings: settings,
        );
      case certificates:
        return MaterialPageRoute(builder: (_) => const CertificatesScreen(), settings: settings);
      case resume:
        return MaterialPageRoute(builder: (_) => const ResumeScreen(), settings: settings);
      case feedback:
        return MaterialPageRoute(builder: (_) => const FeedbackScreen(), settings: settings);
      case security:
        return MaterialPageRoute(builder: (_) => const SecurityScreen(), settings: settings);
      case gallery:
        return MaterialPageRoute(builder: (_) => const GalleryScreen(), settings: settings);
      case contact:
        return MaterialPageRoute(builder: (_) => const ContactScreen(), settings: settings);
      case services:
        return MaterialPageRoute(builder: (_) => const ServicesScreen(showBottomNav: false), settings: settings);
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen(showBottomNav: false), settings: settings);
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            backgroundColor: const Color(0xFF090D16),
            body: Center(
              child: Text(
                'Route not found: ${settings.name}',
                style: const TextStyle(color: Colors.white70),
              ),
            ),
          ),
          settings: settings,
        );
    }
  }
}

