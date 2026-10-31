class FeedbackRequestModel {
  final String name;
  final String email;
  final String sessionName;
  final String keyTakeaway;
  final String? suggestions;
  final String? recommendation;

  const FeedbackRequestModel({
    required this.name,
    required this.email,
    required this.sessionName,
    required this.keyTakeaway,
    this.suggestions,
    this.recommendation,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name.trim(),
      'email': email.trim(),
      'session_name': sessionName.trim(),
      'key_takeaway': keyTakeaway.trim(),
      if (suggestions != null && suggestions!.trim().isNotEmpty)
        'suggestions': suggestions!.trim(),
      if (recommendation != null && recommendation!.trim().isNotEmpty)
        'recommendation': recommendation!.trim(),
    };
  }
}

class FeedbackResponseModel {
  final bool status;
  final String message;
  final Map<String, List<String>> errors;

  const FeedbackResponseModel({
    required this.status,
    required this.message,
    this.errors = const {},
  });

  factory FeedbackResponseModel.fromJson(Map<String, dynamic> json) {
    final Map<String, List<String>> errorsMap = {};
    if (json['errors'] is Map) {
      final raw = json['errors'] as Map;
      raw.forEach((key, val) {
        if (val is List) {
          errorsMap[key.toString()] = val.map((e) => e.toString()).toList();
        } else if (val != null) {
          errorsMap[key.toString()] = [val.toString()];
        }
      });
    }

    return FeedbackResponseModel(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      errors: errorsMap,
    );
  }
}
