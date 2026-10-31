/// Central repository of all API endpoint paths and URLs.
class ApiEndpoints {
  ApiEndpoints._();

  /// Root API v1 base URL for InnoVate Connecta services
  static const String baseUrl = 'https://awsdemo.co.in/innovateconnect/api/v1';

  // --- Auth Endpoints ---
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String refreshToken = '$baseUrl/auth/refresh';
  static const String changePassword = '$baseUrl/auth/change-password';

  // --- Profile, Resume & Certification Endpoints ---
  static const String userProfile = '$baseUrl/user/profile';
  static const String userChangePassword = '$baseUrl/user/change-password';
  static const String profile = userProfile;
  static const String certificates = '$baseUrl/profile/certificates';
  static const String resumes = '$baseUrl/profile/resumes';

  // --- Sessions & Masterclasses Endpoints ---
  static const String liveSessions = '$baseUrl/sessions';
  static const String recordedSessions = '$baseUrl/recorded-sessions';
  static const String sessionCategories = '$baseUrl/session-categories';
  static const String recordedCategories = '$baseUrl/session-categories?type=recorded';

  static String recordedSessionDetail(String slug, {String? email, int? userId}) {
    final query = <String>[];
    if (email != null && email.isNotEmpty) query.add('email=${Uri.encodeComponent(email)}');
    if (userId != null) query.add('user_id=$userId');
    final queryString = query.isNotEmpty ? '?${query.join('&')}' : '';
    return '$recordedSessions/$slug$queryString';
  }

  // --- Communication & Feedback ---
  static const String contactUs = '$baseUrl/contact-us';
  static const String feedback = '$baseUrl/feedback';

  // --- Media & Social Proof ---
  static const String galleries = '$baseUrl/galleries';
  static const String galleryCategories = '$baseUrl/gallery-categories';
  static const String testimonials = '$baseUrl/testimonials';
}

