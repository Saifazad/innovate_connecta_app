import '../../../core/base/base_view_model.dart';
import '../models/testimonial_model.dart';
import '../repository/testimonials_repository.dart';

class TestimonialsViewModel extends BaseViewModel {
  final TestimonialsRepository _repository;

  TestimonialsViewModel({TestimonialsRepository? repository})
      : _repository = repository ?? TestimonialsRepository();

  List<TestimonialModel> _testimonials = [];
  int _ratingFilter = 0; // 0 means 'All'

  List<TestimonialModel> get allTestimonials => _testimonials;
  int get ratingFilter => _ratingFilter;

  /// Filtered list based on rating filter selection
  List<TestimonialModel> get testimonials {
    if (_ratingFilter <= 0) {
      return _testimonials;
    }
    return _testimonials
        .where((item) => item.rating >= _ratingFilter)
        .toList();
  }

  /// Average rating calculation
  double get averageRating {
    if (_testimonials.isEmpty) return 5.0;
    final total = _testimonials.fold<double>(
      0.0,
      (sum, item) => sum + item.rating,
    );
    return total / _testimonials.length;
  }

  /// Total count of verified testimonials
  int get verifiedCount {
    return _testimonials.where((t) => t.isVerified).length;
  }

  /// Set star rating filter (0 for All)
  void setRatingFilter(int rating) {
    if (_ratingFilter == rating) {
      _ratingFilter = 0; // Toggle off to show all
    } else {
      _ratingFilter = rating;
    }
    notifyListeners();
  }

  /// Fetch active testimonials from repository
  Future<void> fetchTestimonials({bool isRefresh = false}) async {
    if (!isRefresh) {
      setBusy(true);
    }

    try {
      final response = await _repository.fetchTestimonials();

      if (response.status) {
        _testimonials = response.data;
        clearError();
      } else {
        setError(
          response.message.isNotEmpty
              ? response.message
              : 'Failed to load testimonials. Please try again.',
        );
      }
    } catch (e) {
      setError('An unexpected error occurred: $e');
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
