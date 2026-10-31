import 'package:flutter/foundation.dart';
import '../../../core/base/base_view_model.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/network/network_exceptions.dart';
import '../models/change_password_request.dart';

class SecurityViewModel extends BaseViewModel {
  final ApiClient _apiClient;
  String? _successMessage;
  Map<String, String> _fieldErrors = {};

  SecurityViewModel({ApiClient? apiClient})
      : _apiClient = apiClient ?? ApiClient();

  String? get successMessage => _successMessage;
  Map<String, String> get fieldErrors => _fieldErrors;

  void clearFieldError(String field) {
    if (_fieldErrors.containsKey(field)) {
      _fieldErrors.remove(field);
      notifyListeners();
    }
  }

  /// Updates user password via API: https://awsdemo.co.in/innovateconnect/api/v1/user/change-password
  Future<bool> updatePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _fieldErrors = {};
    clearError();
    _successMessage = null;

    if (currentPassword.isEmpty) {
      _fieldErrors['current'] = 'Please enter your current password';
    }

    if (newPassword.isEmpty) {
      _fieldErrors['new'] = 'Please enter your new password';
    } else if (newPassword.length < 6) {
      _fieldErrors['new'] = 'New password must be at least 6 characters';
    }

    if (confirmPassword.isEmpty) {
      _fieldErrors['confirm'] = 'Please confirm your new password';
    } else if (confirmPassword != newPassword) {
      _fieldErrors['confirm'] = 'Passwords do not match';
    }

    if (_fieldErrors.isNotEmpty) {
      notifyListeners();
      return false;
    }

    setBusy(true);

    try {
      final request = ChangePasswordRequest(
        currentPassword: currentPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      final response = await _apiClient.post(
        ApiEndpoints.userChangePassword,
        body: request.toJson(),
      );

      String msg = 'Your password has been updated successfully!';
      if (response is Map<String, dynamic> && response['message'] != null) {
        msg = response['message'].toString();
      }

      if (kDebugMode) {
        debugPrint('Password changed response: $response');
      }

      _successMessage = msg;
      setSuccess();
      return true;
    } on NetworkException catch (e) {
      setError(e.message);
      return false;
    } catch (e) {
      setError('Failed to update password: $e');
      return false;
    } finally {
      setBusy(false);
    }
  }
}
