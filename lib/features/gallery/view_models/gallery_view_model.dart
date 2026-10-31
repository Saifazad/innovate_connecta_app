import '../../../core/base/base_view_model.dart';
import '../models/gallery_item.dart';
import '../repository/gallery_repository.dart';

class GalleryViewModel extends BaseViewModel {
  final GalleryRepository _repository;

  GalleryViewModel({GalleryRepository? repository})
      : _repository = repository ?? GalleryRepository();

  List<GalleryItem> _galleries = [];
  List<GalleryCategory> _categories = [];
  int? _selectedCategoryId; // null or 0 = "All Photos"

  List<GalleryItem> get rawGalleries => _galleries;
  List<GalleryCategory> get categories => _categories;
  int? get selectedCategoryId => _selectedCategoryId;

  /// Returns items for display, merging live API data with showcase demo items
  /// so that the grid is full and visually rich as depicted in the design.
  List<GalleryItem> get displayedGalleries {
    final list = <GalleryItem>[..._galleries];

    // If API items are few, supplement with curated showcase items
    for (final showcase in GalleryItem.defaultShowcaseItems) {
      final exists = list.any(
        (g) => g.title.trim().toLowerCase() == showcase.title.trim().toLowerCase(),
      );
      if (!exists) {
        list.add(showcase);
      }
    }

    if (_selectedCategoryId == null || _selectedCategoryId == 0) {
      return list;
    }

    // Filter by selected category ID or category name
    final targetCategory = _categories.cast<GalleryCategory?>().firstWhere(
      (c) => c?.id == _selectedCategoryId,
      orElse: () => null,
    );

    return list.where((item) {
      if (item.galleryCategoryId == _selectedCategoryId) return true;
      if (targetCategory != null &&
          item.categoryName.toLowerCase() == targetCategory.name.toLowerCase()) {
        return true;
      }
      return false;
    }).toList();
  }

  /// Change active category filter (null or 0 means 'All Photos')
  void selectCategory(int? categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  /// Fetch both categories and galleries from the remote API
  Future<void> fetchGalleries({bool isRefresh = false}) async {
    if (!isRefresh) {
      setBusy(true);
    }

    try {
      final results = await Future.wait([
        _repository.fetchGalleries(),
        _repository.fetchCategories(),
      ]);

      final galleriesResponse = results[0] as GalleriesResponse;
      final categoriesResponse = results[1] as GalleryCategoriesResponse;

      if (galleriesResponse.status) {
        _galleries = galleriesResponse.data;
        clearError();
      } else {
        setError(
          galleriesResponse.message.isNotEmpty
              ? galleriesResponse.message
              : 'Unable to retrieve gallery images.',
        );
      }

      if (categoriesResponse.status && categoriesResponse.data.isNotEmpty) {
        _categories = categoriesResponse.data;
      } else if (_categories.isEmpty) {
        // Fallback default categories matching the mockup
        _categories = const [
          GalleryCategory(id: 2, name: 'Campus Drives', slug: 'campus-drives'),
          GalleryCategory(id: 3, name: 'Corporate Sessions', slug: 'corporate-sessions'),
          GalleryCategory(id: 1, name: 'Workshops', slug: 'workshops'),
          GalleryCategory(id: 4, name: 'Student Success', slug: 'student-success'),
        ];
      }
    } catch (e) {
      setError('An error occurred while loading gallery: $e');
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
