import 'package:flutter/foundation.dart';

/// Standard view states for asynchronous data flows
enum ViewState {
  idle,
  busy,
  error,
  success,
}

/// Abstract base ViewModel eliminating boilerplate loading, busy, and error states.
/// All feature ViewModels inherit from this class to ensure consistent state management.
abstract class BaseViewModel extends ChangeNotifier {
  ViewState _state = ViewState.idle;
  String? _errorMessage;
  bool _disposed = false;

  ViewState get state => _state;
  bool get isBusy => _state == ViewState.busy;
  bool get isLoading => isBusy; // Backward-compatible alias for existing UI listeners
  bool get isIdle => _state == ViewState.idle;
  bool get isSuccess => _state == ViewState.success;
  bool get hasError => _state == ViewState.error || (_errorMessage != null && _errorMessage!.isNotEmpty);
  String? get errorMessage => _errorMessage;
  bool get isDisposed => _disposed;

  /// Sets or clears the error message via setter
  set errorMessage(String? value) {
    if (value != null && value.isNotEmpty) {
      setError(value);
    } else {
      clearError();
    }
  }

  /// Sets state to busy (true) or idle (false)
  void setBusy(bool value) {
    if (_disposed) return;
    _state = value ? ViewState.busy : ViewState.idle;
    if (value) {
      _errorMessage = null;
    }
    notifyListeners();
  }

  /// Sets state explicitly
  void setState(ViewState newState) {
    if (_disposed) return;
    _state = newState;
    notifyListeners();
  }

  /// Sets an error message and transitions state to error
  void setError(String? message) {
    if (_disposed) return;
    _errorMessage = message;
    _state = (message != null && message.isNotEmpty) ? ViewState.error : ViewState.idle;
    notifyListeners();
  }

  /// Clears any existing error
  void clearError() {
    if (_disposed) return;
    _errorMessage = null;
    if (_state == ViewState.error) {
      _state = ViewState.idle;
    }
    notifyListeners();
  }

  /// Transitions state to success
  void setSuccess() {
    if (_disposed) return;
    _errorMessage = null;
    _state = ViewState.success;
    notifyListeners();
  }

  /// Safe notifyListeners guarded against disposed state
  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
