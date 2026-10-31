import '../../../core/base/base_view_model.dart';
import '../models/feedback_request_model.dart';
import '../repository/feedback_repository.dart';

class FeedbackViewModel extends BaseViewModel {
  final FeedbackRepository _repository;

  FeedbackViewModel({FeedbackRepository? repository})
      : _repository = repository ?? FeedbackRepository();

  String? _successMessage;
  Map<String, String> _fieldErrors = {};

  String? _selectedSession;
  String _selectedRecommendation = 'Yes, Absolutely!';

  static const List<String> availableSessions = [
    'Full Stack Cloud & DevOps Masterclass',
    'Hands-on Tech Bootcamp',
    'Campus Recruitment Training',
    'Career on Patents & IP',
    'System Design & Cloud Architecture',
    'Corporate Leadership Meetup',
  ];

  bool get isSubmitting => isBusy;
  String? get successMessage => _successMessage;
  Map<String, String> get fieldErrors => _fieldErrors;
  String? get selectedSession => _selectedSession;
  String get selectedRecommendation => _selectedRecommendation;

  void setSession(String? session) {
    _selectedSession = session;
    if (_fieldErrors.containsKey('session_name')) {
      _fieldErrors.remove('session_name');
    }
    notifyListeners();
  }

  void setRecommendation(String value) {
    _selectedRecommendation = value;
    notifyListeners();
  }

  void clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      _fieldErrors.remove(field);
      notifyListeners();
    }
  }

  Future<bool> submitFeedback({
    required String name,
    required String email,
    required String keyTakeaway,
    String? suggestions,
  }) async {
    _fieldErrors = {};
    clearError();
    _successMessage = null;

    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final session = _selectedSession ?? '';
    final trimmedTakeaway = keyTakeaway.trim();

    // Validations
    if (trimmedName.isEmpty) {
      _fieldErrors['name'] = 'Please enter your full name';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (trimmedEmail.isEmpty) {
      _fieldErrors['email'] = 'Please enter your email address';
    } else if (!emailRegex.hasMatch(trimmedEmail)) {
      _fieldErrors['email'] = 'Please enter a valid email address';
    }

    if (session.isEmpty) {
      _fieldErrors['session_name'] = 'Please select the session you attended';
    }

    if (trimmedTakeaway.isEmpty) {
      _fieldErrors['key_takeaway'] = 'Please fill in this field.';
    }

    if (_fieldErrors.isNotEmpty) {
      setError('Please complete the required feedback fields.');
      return false;
    }

    setBusy(true);

    try {
      final request = FeedbackRequestModel(
        name: trimmedName,
        email: trimmedEmail,
        sessionName: session,
        keyTakeaway: trimmedTakeaway,
        suggestions: suggestions?.trim(),
        recommendation: _selectedRecommendation,
      );

      final response = await _repository.submitFeedback(request);

      if (response.status) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : 'Thank you for your valuable feedback! We appreciate your insights.';
        clearError();
        _fieldErrors.clear();
        _selectedSession = null;
        setSuccess();
        return true;
      } else {
        final err = response.message.isNotEmpty
            ? response.message
            : 'Failed to submit feedback. Please try again.';
        setError(err);

        if (response.errors.isNotEmpty) {
          response.errors.forEach((k, v) {
            if (v.isNotEmpty) _fieldErrors[k] = v.first;
          });
        }
        return false;
      }
    } catch (e) {
      setError('An unexpected error occurred: $e');
      return false;
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
