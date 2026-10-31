import '../../../core/base/base_view_model.dart';
import '../../../core/services/auth_session_service.dart';
import '../../../core/services/purchased_sessions_service.dart';
import '../../profile/repository/certificates_repository.dart';
import '../../profile/repository/profile_repository.dart';
import '../../sessions/models/live_session_model.dart';
import '../../sessions/models/recorded_session_model.dart';
import '../../sessions/repository/sessions_repository.dart';

class DashboardViewModel extends BaseViewModel {
  final SessionsRepository _sessionsRepository;
  final CertificatesRepository _certificatesRepository;
  final PurchasedSessionsService _purchasedSessionsService;

  DashboardViewModel({
    SessionsRepository? sessionsRepository,
    CertificatesRepository? certificatesRepository,
    PurchasedSessionsService? purchasedSessionsService,
  }) : _sessionsRepository = sessionsRepository ?? SessionsRepository(),
       _certificatesRepository =
           certificatesRepository ?? CertificatesRepository(),
       _purchasedSessionsService =
           purchasedSessionsService ?? PurchasedSessionsService.instance;

  int _liveSessionsCount = 3;
  int get liveSessionsCount => _liveSessionsCount;

  int _recordedSessionsCount = 5;
  int get recordedSessionsCount => _recordedSessionsCount;

  final int _resourcesCount = 8;
  int get resourcesCount => _resourcesCount;

  int _certificatesCount = 2;
  int get certificatesCount => _certificatesCount;

  List<LiveSessionModel> _upcomingLiveSessions = LiveSessionModel
      .defaultShowcaseSessions
      .take(3)
      .toList();
  List<LiveSessionModel> get upcomingLiveSessions => _upcomingLiveSessions;

  List<RecordedSessionModel> _purchasedRecordedSessions = [];
  List<RecordedSessionModel> get purchasedRecordedSessions =>
      _purchasedRecordedSessions;
  int get purchasedSessionsCount => _purchasedRecordedSessions.length;

  /// Dynamic registered user name from session or profile
  String get registeredUserName {
    final authUser = AuthSessionService.instance.user;
    if (authUser != null && authUser.name.trim().isNotEmpty) {
      return authUser.name.trim();
    }
    final profileName = ProfileRepository.instance.currentProfile.name.trim();
    if (profileName.isNotEmpty &&
        !profileName.toLowerCase().contains('adil khan')) {
      return profileName;
    }
    if (profileName.isNotEmpty) {
      return profileName;
    }
    return 'Amar';
  }

  /// First name for "Welcome back, {Name}! 👋" greeting
  String get greetingName {
    final full = registeredUserName;
    final parts = full.split(' ').where((s) => s.trim().isNotEmpty).toList();
    if (parts.isNotEmpty) {
      return parts.first;
    }
    return 'Amar';
  }

  /// Profile image URL if available
  String? get profileImageUrl {
    final profile = ProfileRepository.instance.currentProfile;
    final url = profile.avatarUrl;
    if (url != null && url.isNotEmpty) {
      return url;
    }
    return null;
  }

  Future<void> loadDashboardData() async {
    setBusy(true);

    // 1. Fetch Live Sessions
    try {
      final liveSessions = await _sessionsRepository.fetchLiveSessions();
      if (liveSessions.isNotEmpty) {
        _liveSessionsCount = liveSessions.length;
        _upcomingLiveSessions = liveSessions.take(3).toList();
      } else {
        _upcomingLiveSessions = LiveSessionModel.defaultShowcaseSessions
            .take(3)
            .toList();
        _liveSessionsCount = 3;
      }
    } catch (_) {
      _upcomingLiveSessions = LiveSessionModel.defaultShowcaseSessions
          .take(3)
          .toList();
      _liveSessionsCount = 3;
    }

    // 2. Fetch Recorded Sessions & User Purchases
    try {
      final recSessions = await _sessionsRepository.fetchRecordedSessions();
      if (recSessions.isNotEmpty) {
        _recordedSessionsCount = recSessions.length;
        // Check if any returned session has isEnrolled == true from backend
        for (final s in recSessions) {
          if (s.isEnrolled) {
            await _purchasedSessionsService.recordPurchase(session: s);
          }
        }
      } else {
        _recordedSessionsCount = 5;
      }
    } catch (_) {
      _recordedSessionsCount = 5;
    }

    // 3. Load user-purchased recorded sessions from student recorded-orders API & local service
    try {
      final user = AuthSessionService.instance.user;
      final userEmail = user?.email ?? AuthSessionService.instance.userEmail;
      final userId = (user?.id != null && user!.id > 0) ? user.id : 0;

      await _purchasedSessionsService.syncFromApi(
        email: userEmail,
        userId: userId,
        repository: _sessionsRepository,
      );

      _purchasedRecordedSessions = _purchasedSessionsService
          .getPurchasedSessions(email: userEmail);
    } catch (_) {
      _purchasedRecordedSessions =
          _purchasedSessionsService.getPurchasedSessions();
    }

    // 4. Fetch Certificates
    try {
      final certs = await _certificatesRepository.fetchCertificates();
      if (certs.isNotEmpty) {
        _certificatesCount = certs.length;
      } else {
        _certificatesCount = 2;
      }
    } catch (_) {
      _certificatesCount = 2;
    }

    setBusy(false);
  }
}
