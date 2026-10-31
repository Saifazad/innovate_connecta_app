import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/feedback_request_model.dart';

class FeedbackRepository {
  static const String endpointUrl =
      'https://awsdemo.co.in/innovateconnect/api/v1/feedback';

  final http.Client _client;

  FeedbackRepository({http.Client? client}) : _client = client ?? http.Client();

  /// Submit session & program feedback to remote API
  Future<FeedbackResponseModel> submitFeedback(FeedbackRequestModel request) async {
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

      final Map<String, dynamic> json =
          jsonDecode(response.body) is Map<String, dynamic>
              ? jsonDecode(response.body) as Map<String, dynamic>
              : {};

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return FeedbackResponseModel.fromJson(json);
      } else if (response.statusCode == 422) {
        return FeedbackResponseModel.fromJson(json);
      } else {
        return FeedbackResponseModel(
          status: false,
          message: json['message'] as String? ??
              'Server responded with status ${response.statusCode}.',
        );
      }
    } on SocketException {
      return const FeedbackResponseModel(
        status: false,
        message: 'No internet connection. Please check your network and try again.',
      );
    } on http.ClientException catch (e) {
      return FeedbackResponseModel(
        status: false,
        message: 'Network error: ${e.message}',
      );
    } catch (e) {
      return FeedbackResponseModel(
        status: false,
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
