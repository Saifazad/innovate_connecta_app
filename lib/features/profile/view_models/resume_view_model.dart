import 'package:file_picker/file_picker.dart';
import '../../../core/base/base_view_model.dart';
import '../models/resume_model.dart';
import '../repository/resume_repository.dart';

class ResumeViewModel extends BaseViewModel {
  final ResumeRepository _repository;

  ResumeViewModel({ResumeRepository? repository})
      : _repository = repository ?? ResumeRepository();

  bool _isUploading = false;
  String? _successMessage;

  String? _selectedFileName;
  String? _selectedFilePath;
  String? _selectedFileTitle;
  List<int>? _selectedFileBytes;
  String? _selectedFileSize;

  ResumeModel _activeResume = ResumeModel.defaultActiveResume;

  bool get isUploading => _isUploading;
  String? get successMessage => _successMessage;

  String? get selectedFileName => _selectedFileName;
  String? get selectedFilePath => _selectedFilePath;
  String? get selectedFileTitle => _selectedFileTitle;
  List<int>? get selectedFileBytes => _selectedFileBytes;
  String? get selectedFileSize => _selectedFileSize;
  ResumeModel get activeResume => _activeResume;

  Future<void> loadActiveResume() async {
    setBusy(true);
    try {
      final resume = await _repository.fetchActiveResume();
      if (resume != null) {
        _activeResume = resume;
      }
      clearError();
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }

  /// Pick PDF resume adhering to the registration screen logic
  Future<bool> pickResumeFile() async {
    try {
      clearError();
      _successMessage = null;

      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (file == null) return false;

      // Verify PDF extension
      if (file.extension?.toLowerCase() != 'pdf') {
        setError('Please select a valid PDF file.');
        return false;
      }

      final fileSize = (await file.length()) ?? 0;

      // 10MB limit constraint
      if (fileSize > 10 * 1024 * 1024) {
        setError('File exceeds 10MB limit. Please choose a smaller PDF document.');
        return false;
      }

      final double sizeInMb = fileSize / (1024 * 1024);
      final String sizeStr = sizeInMb >= 1.0
          ? '${sizeInMb.toStringAsFixed(1)} MB'
          : '${(fileSize / 1024).toStringAsFixed(0)} KB';

      final fileBytes = await file.readAsBytes();

      _selectedFileName = file.name;
      _selectedFilePath = file.path;
      _selectedFileBytes = fileBytes;
      _selectedFileSize = sizeStr;
      _selectedFileTitle = file.name.replaceAll(RegExp(r'\.pdf$', caseSensitive: false), '').trim();
      clearError();
      notifyListeners();
      return true;
    } catch (e) {
      setError('Could not select resume: $e');
      return false;
    }
  }

  void removeSelectedFile() {
    _selectedFileName = null;
    _selectedFilePath = null;
    _selectedFileTitle = null;
    _selectedFileBytes = null;
    _selectedFileSize = null;
    clearError();
    notifyListeners();
  }

  void clearMessages() {
    clearError();
    _successMessage = null;
    notifyListeners();
  }

  Future<bool> uploadResume({required String title}) async {
    if (_selectedFileName == null) {
      setError('Please select a PDF resume file first.');
      return false;
    }

    _isUploading = true;
    clearError();
    _successMessage = null;
    notifyListeners();

    try {
      final newResume = ResumeModel(
        id: 'res_${DateTime.now().millisecondsSinceEpoch}',
        fileName: _selectedFileName!,
        filePath: _selectedFilePath,
        fileSize: _selectedFileSize ?? '1.2 MB',
        title: title.trim().isNotEmpty ? title.trim() : (_selectedFileTitle ?? 'Resume'),
        uploadedAt: 'Uploaded on today',
        isVerified: true,
        isAtsReady: true,
      );

      await _repository.saveResume(newResume);
      _activeResume = newResume;
      _successMessage = 'Resume uploaded and saved successfully!';
      removeSelectedFile();
      setSuccess();
      return true;
    } catch (e) {
      setError('Failed to upload resume: $e');
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
