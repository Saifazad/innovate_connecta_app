import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/testimonial_model.dart';

class TestimonialsRepository {
  static const String endpointUrl =
      'https://awsdemo.co.in/innovateconnect/api/v1/testimonials';

  final http.Client _client;

  TestimonialsRepository({http.Client? client})
      : _client = client ?? http.Client();

  /// Fetch active testimonials list from API
  Future<TestimonialsResponse> fetchTestimonials() async {
    try {
      final uri = Uri.parse(endpointUrl);
      final response = await _client.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> json =
            jsonDecode(response.body) as Map<String, dynamic>;
        return TestimonialsResponse.fromJson(json);
      } else {
        return TestimonialsResponse(
          status: false,
          message:
              'Server responded with status ${response.statusCode}. Please try again later.',
          data: [],
        );
      }
    } on SocketException {
      return const TestimonialsResponse(
        status: false,
        message:
            'No internet connection. Please check your network and try again.',
        data: [],
      );
    } on http.ClientException catch (e) {
      return TestimonialsResponse(
        status: false,
        message: 'Network error: ${e.message}',
        data: [],
      );
    } catch (e) {
      return TestimonialsResponse(
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
