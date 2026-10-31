import '../../../core/base/base_view_model.dart';
import '../models/contact_request.dart';
import '../repository/contact_repository.dart';

class ContactViewModel extends BaseViewModel {
  final ContactRepository _repository;

  ContactViewModel({ContactRepository? repository})
      : _repository = repository ?? ContactRepository();

  String? _successMessage;
  Map<String, String> _fieldErrors = {};
  String? _selectedSubject;

  static const List<String> subjects = [
    'General Inquiry',
    'Campus Drives',
    'Corporate Workshops',
    'Masterclasses & Bootcamps',
    'Internship Assistance',
    'Partnership & Collaborations',
  ];

  bool get isSubmitting => isBusy;
  String? get successMessage => _successMessage;
  Map<String, String> get fieldErrors => _fieldErrors;
  String? get selectedSubject => _selectedSubject;

  void setSubject(String? subject) {
    _selectedSubject = subject;
    if (_fieldErrors.containsKey('subject')) {
      _fieldErrors.remove('subject');
    }
    notifyListeners();
  }

  void clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      _fieldErrors.remove(field);
      notifyListeners();
    }
  }

  void resetStatus() {
    clearError();
    _successMessage = null;
    _fieldErrors.clear();
    notifyListeners();
  }

  /// Submit contact inquiry form with client & server validation
  Future<bool> submitForm({
    required String name,
    required String email,
    required String phone,
    required String message,
  }) async {
    _fieldErrors = {};
    clearError();
    _successMessage = null;

    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedPhone = phone.trim();
    final trimmedMessage = message.trim();
    final subject = _selectedSubject ?? '';

    // Client-side validations
    if (trimmedName.isEmpty) {
      _fieldErrors['name'] = 'Please enter your full name';
    } else if (trimmedName.length < 2) {
      _fieldErrors['name'] = 'Name must be at least 2 characters';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (trimmedEmail.isEmpty) {
      _fieldErrors['email'] = 'Please enter your email address';
    } else if (!emailRegex.hasMatch(trimmedEmail)) {
      _fieldErrors['email'] = 'Please enter a valid email address';
    }

    if (trimmedPhone.isEmpty) {
      _fieldErrors['phone'] = 'Please enter your phone number';
    } else if (trimmedPhone.replaceAll(RegExp(r'\D'), '').length < 7) {
      _fieldErrors['phone'] = 'Please enter a valid phone number';
    }

    if (subject.isEmpty) {
      _fieldErrors['subject'] = 'Please select an inquiry topic';
    }

    if (trimmedMessage.isEmpty) {
      _fieldErrors['message'] = 'Please enter your message';
    } else if (trimmedMessage.length < 5) {
      _fieldErrors['message'] = 'Message must be at least 5 characters';
    }

    if (_fieldErrors.isNotEmpty) {
      setError('Please fix the highlighted fields above.');
      return false;
    }

    setBusy(true);

    try {
      final request = ContactRequest(
        name: trimmedName,
        email: trimmedEmail,
        phone: trimmedPhone,
        subject: subject,
        message: trimmedMessage,
      );

      final response = await _repository.submitContactForm(request);

      if (response.status) {
        _successMessage = response.message.isNotEmpty
            ? response.message
            : 'Thank you for reaching out! An advisor will get back to you within 24 hours.';
        clearError();
        _fieldErrors.clear();
        _selectedSubject = null;
        setSuccess();
        return true;
      } else {
        final err = response.message.isNotEmpty
            ? response.message
            : 'Failed to send message. Please try again.';
        setError(err);

        // Populate server field errors if available
        if (response.errors.isNotEmpty) {
          response.errors.forEach((key, list) {
            if (list.isNotEmpty) {
              _fieldErrors[key] = list.first;
            }
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
