import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:innovate_connecta_app/features/gallery/models/gallery_item.dart';
import 'package:innovate_connecta_app/features/gallery/repository/gallery_repository.dart';
import 'package:innovate_connecta_app/features/gallery/view_models/gallery_view_model.dart';

void main() {
  const sampleGalleriesJson = '''
  {
    "status": true,
    "message": "Active galleries retrieved successfully",
    "data": [
      {
        "id": 2,
        "gallery_category_id": 1,
        "title": "food",
        "location": "delhi",
        "image": "galleries/GQLzwIGI68yVayjeWWZ2I0lCx7VYgOdnoU6oWTtB.jpg",
        "is_active": true,
        "created_at": "2026-09-16T10:52:49.000000Z",
        "updated_at": "2026-09-18T04:27:08.000000Z",
        "image_url": "https://awsdemo.co.in/innovateconnect/storage/galleries/GQLzwIGI68yVayjeWWZ2I0lCx7VYgOdnoU6oWTtB.jpg",
        "category": {
          "id": 1,
          "name": "Workshops",
          "slug": "workshops",
          "is_active": true,
          "created_at": "2026-09-15T12:53:35.000000Z",
          "updated_at": "2026-09-15T12:53:35.000000Z"
        }
      },
      {
        "id": 1,
        "gallery_category_id": 2,
        "title": "test",
        "location": "delhi",
        "image": "galleries/9qBwrCdmBSVlVtEOUjzL7hR6WM1CJMkRlFeEKrDP.png",
        "is_active": true,
        "created_at": "2026-09-15T12:55:18.000000Z",
        "updated_at": "2026-09-15T12:55:18.000000Z",
        "image_url": "https://awsdemo.co.in/innovateconnect/storage/galleries/9qBwrCdmBSVlVtEOUjzL7hR6WM1CJMkRlFeEKrDP.png",
        "category": {
          "id": 2,
          "name": "Campus Drives",
          "slug": "campus-drives",
          "is_active": true,
          "created_at": "2026-09-15T12:53:35.000000Z",
          "updated_at": "2026-09-15T12:53:35.000000Z"
        }
      }
    ]
  }
  ''';

  const sampleCategoriesJson = '''
  {
    "status": true,
    "message": "Active gallery categories retrieved successfully",
    "data": [
      {
        "id": 1,
        "name": "Workshops",
        "slug": "workshops",
        "is_active": true,
        "galleries_count": 1
      },
      {
        "id": 2,
        "name": "Campus Drives",
        "slug": "campus-drives",
        "is_active": true,
        "galleries_count": 1
      }
    ]
  }
  ''';

  group('Gallery Model Tests', () {
    test('GalleryItem and GalleriesResponse deserialize correctly', () {
      final jsonMap = jsonDecode(sampleGalleriesJson) as Map<String, dynamic>;
      final response = GalleriesResponse.fromJson(jsonMap);

      expect(response.status, true);
      expect(response.data.length, 2);

      final first = response.data.first;
      expect(first.id, 2);
      expect(first.title, 'food');
      expect(first.location, 'delhi');
      expect(first.categoryName, 'Workshops');
      expect(first.imageUrl,
          'https://awsdemo.co.in/innovateconnect/storage/galleries/GQLzwIGI68yVayjeWWZ2I0lCx7VYgOdnoU6oWTtB.jpg');
    });

    test('GalleryCategory and GalleryCategoriesResponse deserialize correctly', () {
      final jsonMap = jsonDecode(sampleCategoriesJson) as Map<String, dynamic>;
      final response = GalleryCategoriesResponse.fromJson(jsonMap);

      expect(response.status, true);
      expect(response.data.length, 2);
      expect(response.data.first.name, 'Workshops');
    });
  });

  group('Gallery Repository Tests', () {
    test('fetchGalleries returns items on 200 OK', () async {
      final mockClient = MockClient((request) async {
        return http.Response(sampleGalleriesJson, 200,
            headers: {'content-type': 'application/json'});
      });

      final repo = GalleryRepository(client: mockClient);
      final res = await repo.fetchGalleries();

      expect(res.status, true);
      expect(res.data.length, 2);
      expect(res.data[0].title, 'food');
    });

    test('fetchCategories returns categories on 200 OK', () async {
      final mockClient = MockClient((request) async {
        return http.Response(sampleCategoriesJson, 200,
            headers: {'content-type': 'application/json'});
      });

      final repo = GalleryRepository(client: mockClient);
      final res = await repo.fetchCategories();

      expect(res.status, true);
      expect(res.data.length, 2);
    });
  });

  group('Gallery ViewModel Tests', () {
    test('selectCategory filters displayed items', () async {
      final mockClient = MockClient((request) async {
        if (request.url.path.contains('categories')) {
          return http.Response(sampleCategoriesJson, 200,
              headers: {'content-type': 'application/json'});
        }
        return http.Response(sampleGalleriesJson, 200,
            headers: {'content-type': 'application/json'});
      });

      final repo = GalleryRepository(client: mockClient);
      final vm = GalleryViewModel(repository: repo);

      await vm.fetchGalleries();

      expect(vm.isLoading, false);
      expect(vm.errorMessage, isNull);
      expect(vm.rawGalleries.length, 2);

      // Category filter test
      vm.selectCategory(1); // Workshops
      expect(vm.selectedCategoryId, 1);
      final filtered = vm.displayedGalleries;
      expect(filtered.any((item) => item.categoryName == 'Workshops'), true);
    });
  });
}
