import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/gallery_item.dart';

class GalleryRepository {
  static const String galleriesEndpoint =
      'https://awsdemo.co.in/innovateconnect/api/v1/galleries';
  static const String categoriesEndpoint =
      'https://awsdemo.co.in/innovateconnect/api/v1/gallery-categories';

  final http.Client _client;

  GalleryRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Fetch active galleries from API, optionally filtered by category
  Future<GalleriesResponse> fetchGalleries({int? categoryId}) async {
    try {
      final uri = Uri.parse(
        categoryId != null && categoryId > 0
            ? '$galleriesEndpoint?gallery_category_id=$categoryId'
            : galleriesEndpoint,
      );

      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return GalleriesResponse.fromJson(json);
      } else {
        return GalleriesResponse(
          status: false,
          message:
              'Server returned status ${response.statusCode}. Please try again later.',
          data: [],
        );
      }
    } on SocketException {
      return const GalleriesResponse(
        status: false,
        message:
            'No internet connection. Please check your network and try again.',
        data: [],
      );
    } on http.ClientException catch (e) {
      return GalleriesResponse(
        status: false,
        message: 'Network error: ${e.message}',
        data: [],
      );
    } catch (e) {
      return GalleriesResponse(
        status: false,
        message: 'An unexpected error occurred: $e',
        data: [],
      );
    }
  }

  /// Fetch active gallery categories
  Future<GalleryCategoriesResponse> fetchCategories() async {
    try {
      final uri = Uri.parse(categoriesEndpoint);
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return GalleryCategoriesResponse.fromJson(json);
      } else {
        return GalleryCategoriesResponse(
          status: false,
          message:
              'Server returned status ${response.statusCode}. Please try again later.',
          data: [],
        );
      }
    } on SocketException {
      return const GalleryCategoriesResponse(
        status: false,
        message:
            'No internet connection. Please check your network and try again.',
        data: [],
      );
    } on http.ClientException catch (e) {
      return GalleryCategoriesResponse(
        status: false,
        message: 'Network error: ${e.message}',
        data: [],
      );
    } catch (e) {
      return GalleryCategoriesResponse(
        status: false,
        message: 'An unexpected error occurred: $e',
        data: [],
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
