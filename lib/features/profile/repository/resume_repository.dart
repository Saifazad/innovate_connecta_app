import '../../../core/services/database_service.dart';
import '../models/resume_model.dart';

class ResumeRepository {
  final DatabaseService _db;
  ResumeModel? _activeResume;

  ResumeRepository({DatabaseService? db}) : _db = db ?? DatabaseService.instance;

  Future<ResumeModel?> fetchActiveResume() async {
    final cached = _db.getActiveResume();
    if (cached != null) {
      _activeResume = cached;
      return cached;
    }
    if (_activeResume != null) return _activeResume;
    return ResumeModel.defaultActiveResume;
  }

  Future<bool> saveResume(ResumeModel resume) async {
    _activeResume = resume;
    _db.saveActiveResume(resume);
    return true;
  }
}
