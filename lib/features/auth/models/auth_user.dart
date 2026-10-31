class AuthUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? field;
  final String? resumePath;
  final String? resumeUrl;
  final String? resumeTitle;
  final String? resumeSize;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;

  const AuthUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.field,
    this.resumePath,
    this.resumeUrl,
    this.resumeTitle,
    this.resumeSize,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      field: json['field'] as String?,
      resumePath: json['resume_path'] as String?,
      resumeUrl: json['resume_url'] as String?,
      resumeTitle: json['resume_title'] as String?,
      resumeSize: json['resume_size'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'field': field,
      'resume_path': resumePath,
      'resume_url': resumeUrl,
      'resume_title': resumeTitle,
      'resume_size': resumeSize,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
