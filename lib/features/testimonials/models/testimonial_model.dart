class TestimonialModel {
  final int id;
  final String name;
  final String designation;
  final String review;
  final double rating;
  final String? avatar;
  final bool isVerified;
  final bool isFeatured;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final String? avatarUrl;
  final String initials;

  const TestimonialModel({
    required this.id,
    required this.name,
    required this.designation,
    required this.review,
    required this.rating,
    this.avatar,
    this.isVerified = false,
    this.isFeatured = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.avatarUrl,
    required this.initials,
  });

  factory TestimonialModel.fromJson(Map<String, dynamic> json) {
    return TestimonialModel(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Anonymous',
      designation: json['designation'] as String? ?? '',
      review: json['review'] as String? ?? '',
      rating: (json['rating'] is num) ? (json['rating'] as num).toDouble() : 5.0,
      avatar: json['avatar'] as String?,
      isVerified: json['is_verified'] as bool? ?? false,
      isFeatured: json['is_featured'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      initials: (json['initials'] as String?)?.isNotEmpty == true
          ? json['initials'] as String
          : _deriveInitials(json['name'] as String? ?? ''),
    );
  }

  static String _deriveInitials(String fullName) {
    final trimmed = fullName.trim();
    if (trimmed.isEmpty) return 'U';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'designation': designation,
      'review': review,
      'rating': rating,
      'avatar': avatar,
      'is_verified': isVerified,
      'is_featured': isFeatured,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'avatar_url': avatarUrl,
      'initials': initials,
    };
  }
}

class TestimonialsResponse {
  final bool status;
  final String message;
  final List<TestimonialModel> data;

  const TestimonialsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TestimonialsResponse.fromJson(Map<String, dynamic> json) {
    List<TestimonialModel> testimonialsList = [];
    if (json['data'] is List) {
      testimonialsList = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((item) => TestimonialModel.fromJson(item))
          .toList();
    }

    return TestimonialsResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: testimonialsList,
    );
  }
}
