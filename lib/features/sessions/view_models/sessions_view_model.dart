import 'dart:io';
import '../../../core/base/base_view_model.dart';
import '../models/live_session_model.dart';
import '../models/recorded_session_model.dart';
import '../models/session_category_model.dart';
import '../repository/sessions_repository.dart';

class SessionsViewModel extends BaseViewModel {
  final SessionsRepository _repository;

  SessionsViewModel({SessionsRepository? repository})
      : _repository = repository ?? SessionsRepository();

  bool _isLoadingLive = false;
  bool _isLoadingRecorded = false;
  bool _isLoadingCategories = false;
  String? _liveError;
  String? _recordedError;

  List<LiveSessionModel> _liveSessions = [];
  List<RecordedSessionModel> _recordedSessions = [];
  List<SessionCategoryModel> _recordedCategoryModels = [];

  String _selectedLiveCategory = 'All Sessions';
  String _selectedRecordedCategory = 'All Library';
  int _selectedRecordedCategoryId = 0;

  // Getters
  bool get isLoadingLive => _isLoadingLive;
  bool get isLoadingRecorded => _isLoadingRecorded;
  bool get isLoadingCategories => _isLoadingCategories;
  @override
  bool get isLoading => _isLoadingLive || _isLoadingRecorded;
  String? get liveError => _liveError;
  String? get recordedError => _recordedError;

  List<LiveSessionModel> get liveSessions => _liveSessions;
  List<RecordedSessionModel> get recordedSessions => _recordedSessions;
  List<SessionCategoryModel> get recordedCategoryModels => _recordedCategoryModels;

  String get selectedLiveCategory => _selectedLiveCategory;
  String get selectedRecordedCategory => _selectedRecordedCategory;
  int get selectedRecordedCategoryId => _selectedRecordedCategoryId;

  /// Dynamic live categories list
  List<String> get liveCategories {
    final set = <String>{'All Sessions'};
    for (final s in _liveSessions) {
      if (s.categoryName.trim().isNotEmpty) {
        set.add(s.categoryName.trim());
      }
    }
    return set.toList();
  }

  /// Dynamic recorded categories models list fetched from API with 'All Library' default
  List<SessionCategoryModel> get recordedCategoryList {
    final list = <SessionCategoryModel>[
      const SessionCategoryModel(id: 0, name: 'All Library', slug: 'all-library'),
    ];
    for (final cat in _recordedCategoryModels) {
      final name = cat.name.trim();
      if (name.isNotEmpty && !list.any((c) => c.id == cat.id || c.name.toLowerCase() == name.toLowerCase())) {
        list.add(cat);
      }
    }
    return list;
  }

  /// Dynamic recorded category names for backward compatibility
  List<String> get recordedCategories {
    return recordedCategoryList.map((c) => c.name).toList();
  }

  List<LiveSessionModel> get filteredLiveSessions {
    if (_selectedLiveCategory == 'All Sessions') {
      return _liveSessions;
    }
    final sel = _selectedLiveCategory.toLowerCase().trim();
    return _liveSessions.where((s) {
      final cat = s.categoryName.toLowerCase().trim();
      return cat == sel || cat.contains(sel) || sel.contains(cat);
    }).toList();
  }

  List<RecordedSessionModel> get filteredRecordedSessions {
    if (_selectedRecordedCategoryId == 0 || _selectedRecordedCategory == 'All Library') {
      return _recordedSessions;
    }
    final sel = _selectedRecordedCategory.toLowerCase().trim();

    return _recordedSessions.where((s) {
      // 1. Primary check: Match by category ID
      if (s.categoryId != null && s.categoryId == _selectedRecordedCategoryId) {
        return true;
      }
      // 2. Secondary fallback: Match by category name
      final cat = s.categoryName.toLowerCase().trim();
      return cat == sel || cat.contains(sel) || sel.contains(cat);
    }).toList();
  }

  void setLiveCategory(String category) {
    if (_selectedLiveCategory != category) {
      _selectedLiveCategory = category;
      notifyListeners();
    }
  }

  void selectRecordedCategory(SessionCategoryModel category) {
    if (_selectedRecordedCategoryId != category.id || _selectedRecordedCategory != category.name) {
      _selectedRecordedCategoryId = category.id;
      _selectedRecordedCategory = category.name;
      notifyListeners();
    }
  }

  void setRecordedCategory(String categoryName) {
    if (_selectedRecordedCategory != categoryName) {
      _selectedRecordedCategory = categoryName;
      // Match ID if available
      final matched = _recordedCategoryModels.where((c) => c.name.toLowerCase() == categoryName.toLowerCase()).firstOrNull;
      _selectedRecordedCategoryId = matched?.id ?? (categoryName == 'All Library' ? 0 : -1);
      notifyListeners();
    }
  }

  Future<void> init() async {
    await Future.wait([
      fetchLiveSessions(),
      fetchRecordedSessions(),
      fetchRecordedCategories(),
    ]);
  }

  Future<void> fetchLiveSessions() async {
    _isLoadingLive = true;
    _liveError = null;
    notifyListeners();

    try {
      final data = await _repository.fetchLiveSessions();
      _liveSessions = data;
      _liveError = null;
    } on SocketException {
      _liveError = 'No internet connection. Please check your network.';
    } catch (e) {
      _liveError = 'Failed to load live sessions: $e';
    } finally {
      _isLoadingLive = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecordedSessions() async {
    _isLoadingRecorded = true;
    _recordedError = null;
    notifyListeners();

    try {
      final data = await _repository.fetchRecordedSessions();
      _recordedSessions = data;
      _recordedError = null;
    } on SocketException {
      _recordedError = 'No internet connection. Please check your network.';
    } catch (e) {
      _recordedError = 'Failed to load recorded sessions: $e';
    } finally {
      _isLoadingRecorded = false;
      notifyListeners();
    }
  }

  Future<void> fetchRecordedCategories() async {
    _isLoadingCategories = true;
    notifyListeners();

    try {
      final data = await _repository.fetchRecordedCategories();
      _recordedCategoryModels = data;
    } catch (_) {
      // Keep existing categories or default All Library
    } finally {
      _isLoadingCategories = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }
}
