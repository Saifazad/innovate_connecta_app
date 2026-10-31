import 'dart:convert';
import 'dart:io';
import '../../features/profile/models/student_profile_model.dart';
import '../../features/profile/models/resume_model.dart';

/// Local database service providing persistent and in-memory storage for user profiles and sessions.
class DatabaseService {
  static DatabaseService? _instance;
  static DatabaseService get instance =>
      _instance ??= DatabaseService._fileBased('${Directory.systemTemp.path}/innovate_connecta_profiles_db.json');

  final Map<String, Map<String, dynamic>> _profilesByEmail = {};
  final Map<String, Map<String, dynamic>> _resumesByEmail = {};
  String? _activeUserEmail;
  File? _dbFile;
  bool _initialized = false;

  /// Default constructor creates an isolated in-memory instance (ideal for tests)
  DatabaseService({String? customDbPath}) {
    if (customDbPath != null) {
      _dbFile = File(customDbPath);
    }
  }

  /// Internal constructor for file-backed persistent instance
  DatabaseService._fileBased(String path) : _dbFile = File(path);

  void init() {
    if (_initialized) return;
    try {
      if (_dbFile != null && _dbFile!.existsSync()) {
        final content = _dbFile!.readAsStringSync();
        if (content.trim().isNotEmpty) {
          final data = jsonDecode(content) as Map<String, dynamic>;
          _activeUserEmail = data['active_user_email'] as String?;
          if (data['profiles'] is Map<String, dynamic>) {
            final profiles = data['profiles'] as Map<String, dynamic>;
            profiles.forEach((key, value) {
              if (value is Map<String, dynamic>) {
                _profilesByEmail[key.toLowerCase()] = Map<String, dynamic>.from(value);
              }
            });
          }
          if (data['resumes'] is Map<String, dynamic>) {
            final resumes = data['resumes'] as Map<String, dynamic>;
            resumes.forEach((key, value) {
              if (value is Map<String, dynamic>) {
                _resumesByEmail[key.toLowerCase()] = Map<String, dynamic>.from(value);
              }
            });
          }
        }
      }
    } catch (_) {
      // In-memory fallback if file system access fails
    }
    _initialized = true;
  }

  String? get activeUserEmail => _activeUserEmail;

  StudentProfileModel? getActiveProfile() {
    init();
    if (_activeUserEmail != null && _activeUserEmail!.isNotEmpty) {
      final key = _activeUserEmail!.toLowerCase().trim();
      final data = _profilesByEmail[key];
      if (data != null) {
        return StudentProfileModel.fromJson(data);
      }
    }
    return null;
  }

  StudentProfileModel? getProfileForUser(String email) {
    init();
    final key = email.toLowerCase().trim();
    final data = _profilesByEmail[key];
    if (data != null) {
      return StudentProfileModel.fromJson(data);
    }
    return null;
  }

  void saveProfile(StudentProfileModel profile) {
    init();
    final key = profile.email.toLowerCase().trim();
    if (key.isNotEmpty) {
      _profilesByEmail[key] = profile.toJson();
      _persist();
    }
  }

  ResumeModel? getActiveResume([String? email]) {
    init();
    final userEmail = email ?? _activeUserEmail ?? 'default_user';
    final data = _resumesByEmail[userEmail.toLowerCase().trim()];
    if (data != null) {
      return ResumeModel.fromJson(data);
    }
    return null;
  }

  void saveActiveResume(ResumeModel resume, [String? email]) {
    init();
    final userEmail = email ?? _activeUserEmail ?? 'default_user';
    _resumesByEmail[userEmail.toLowerCase().trim()] = resume.toJson();
    _persist();
  }

  void setActiveUserEmail(String email) {
    init();
    _activeUserEmail = email.toLowerCase().trim();
    _persist();
  }

  void clearActiveSession() {
    init();
    _activeUserEmail = null;
    _persist();
  }

  void _persist() {
    try {
      if (_dbFile != null) {
        final data = {
          'active_user_email': _activeUserEmail,
          'profiles': _profilesByEmail,
          'resumes': _resumesByEmail,
        };
        _dbFile!.writeAsStringSync(jsonEncode(data), flush: true);
      }
    } catch (_) {
      // Fallback safely to in-memory
    }
  }

  void reset() {
    _profilesByEmail.clear();
    _resumesByEmail.clear();
    _activeUserEmail = null;
    _initialized = false;
    try {
      if (_dbFile != null && _dbFile!.existsSync()) {
        _dbFile!.deleteSync();
      }
    } catch (_) {}
  }

  static void resetInstance() {
    _instance?.reset();
    _instance = null;
  }
}
