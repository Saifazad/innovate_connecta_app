class ContactSubmissionData {
  final int? id;
  final String name;
  final String email;
  final String phone;
  final String subject;
  final String? createdAt;

  const ContactSubmissionData({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.subject,
    this.createdAt,
  });

  factory ContactSubmissionData.fromJson(Map<String, dynamic> json) {
    return ContactSubmissionData(
      id: json['id'] as int?,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      createdAt: json['created_at'] as String?,
    );
  }
}

class ContactResponse {
  final bool status;
  final String message;
  final ContactSubmissionData? data;
  final Map<String, List<String>> errors;

  const ContactResponse({
    required this.status,
    required this.message,
    this.data,
    this.errors = const {},
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    ContactSubmissionData? data;
    if (json['data'] is Map<String, dynamic>) {
      data = ContactSubmissionData.fromJson(json['data'] as Map<String, dynamic>);
    }

    final Map<String, List<String>> errorsMap = {};
    if (json['errors'] is Map) {
      final rawErrors = json['errors'] as Map;
      rawErrors.forEach((key, val) {
        if (val is List) {
          errorsMap[key.toString()] = val.map((e) => e.toString()).toList();
        } else if (val != null) {
          errorsMap[key.toString()] = [val.toString()];
        }
      });
    }

    return ContactResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: data,
      errors: errorsMap,
    );
  }

  /// Convenience helper to extract first validation error for a field
  String? firstErrorFor(String fieldName) {
    final list = errors[fieldName];
    if (list != null && list.isNotEmpty) {
      return list.first;
    }
    return null;
  }
}
