class StudentProfileModel {
  final String name;
  final String email;
  final String phone;
  final String field;
  final String degree;
  final String year;
  final String? avatarUrl;
  final String cohort;
  final bool isMsmeVerified;
  final bool isEmailVerified;

  const StudentProfileModel({
    required this.name,
    required this.email,
    required this.phone,
    String? field,
    String? university,
    this.degree = '',
    this.year = '',
    this.avatarUrl,
    this.cohort = 'Cohort 2024',
    this.isMsmeVerified = true,
    this.isEmailVerified = true,
  }) : field = field ?? university ?? '';

  /// Backward-compatible alias for field
  String get university => field;

  String get fieldTitle => field.trim().isNotEmpty ? field.trim() : 'Add Field / Category';
  String get collegeTitle => fieldTitle;
  bool get isCollegeMissing => field.trim().isEmpty;
  bool get isEducationMissing => degree.trim().isEmpty && year.trim().isEmpty;

  String get programTitle {
    final cleanDegree = degree.trim();
    final cleanYear = year.trim();
    if (cleanDegree.isEmpty && cleanYear.isEmpty) {
      return 'Add Education';
    }
    if (cleanDegree.isEmpty) return cleanYear;
    if (cleanYear.isEmpty) return cleanDegree;
    return '$cleanDegree • $cleanYear';
  }

  StudentProfileModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? field,
    String? university,
    String? degree,
    String? year,
    String? avatarUrl,
    String? cohort,
    bool? isMsmeVerified,
    bool? isEmailVerified,
  }) {
    return StudentProfileModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      field: field ?? university ?? this.field,
      degree: degree ?? this.degree,
      year: year ?? this.year,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      cohort: cohort ?? this.cohort,
      isMsmeVerified: isMsmeVerified ?? this.isMsmeVerified,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
    );
  }

  factory StudentProfileModel.fromJson(Map<String, dynamic> json) {
    final map = (json['data'] is Map<String, dynamic>)
        ? json['data'] as Map<String, dynamic>
        : (json['user'] is Map<String, dynamic>)
            ? json['user'] as Map<String, dynamic>
            : json;

    return StudentProfileModel(
      name: (map['name'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      phone: (map['phone'] ?? '').toString(),
      field: (map['field'] ?? map['category'] ?? map['field_of_study'] ?? map['university'] ?? '').toString(),
      degree: (map['degree'] ?? '').toString(),
      year: (map['year'] ?? '').toString(),
      avatarUrl: map['avatar_url']?.toString() ?? map['avatar']?.toString() ?? map['image']?.toString(),
      cohort: (map['cohort'] ?? 'Cohort 2024').toString(),
      isMsmeVerified: map['is_msme_verified'] == true || map['is_msme_verified'] == 1,
      isEmailVerified: map['is_email_verified'] == true || map['is_email_verified'] == 1 || map['email_verified_at'] != null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'field': field,
      'university': field,
      'degree': degree,
      'year': year,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      'cohort': cohort,
      'is_msme_verified': isMsmeVerified,
      'is_email_verified': isEmailVerified,
    };
  }

  static const StudentProfileModel defaultProfile = StudentProfileModel(
    name: 'Amar Sharma',
    email: 'amar.sharma@example.com',
    phone: '+91 99685 43210',
    field: 'College Student',
    degree: 'B.Tech Computer Science',
    year: 'Final Year',
    cohort: 'Cohort 2024',
    isMsmeVerified: true,
    isEmailVerified: true,
  );
}
