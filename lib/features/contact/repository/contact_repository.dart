import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/contact_request.dart';
import '../models/contact_response.dart';

class ContactRepository {
  static const String endpointUrl =
      'https://awsdemo.co.in/innovateconnect/api/v1/contact-us';

  final http.Client _client;

  ContactRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Submit contact inquiry form to the API
  Future<ContactResponse> submitContactForm(ContactRequest request) async {
    try {
      final uri = Uri.parse(endpointUrl);
      final response = await _client
          .post(
            uri,
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(request.toJson()),
          )
          .timeout(const Duration(seconds: 20));

      final Map<String, dynamic> json = jsonDecode(response.body) is Map<String, dynamic>
          ? jsonDecode(response.body) as Map<String, dynamic>
          : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ContactResponse.fromJson(json);
      } else if (response.statusCode == 422) {
        // Validation Error from server
        return ContactResponse.fromJson(json);
      } else {
        return ContactResponse(
          status: false,
          message: json['message'] as String? ??
              'Server responded with status ${response.statusCode}. Please try again later.',
        );
      }
    } on SocketException {
      return const ContactResponse(
        status: false,
        message:
            'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException catch (e) {
      return ContactResponse(
        status: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return ContactResponse(
        status: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
