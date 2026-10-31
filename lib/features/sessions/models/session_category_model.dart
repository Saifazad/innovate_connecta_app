class SessionCategoryModel {
  final int id;
  final String name;
  final String slug;
  final String type;
  final String? color;
  final bool isActive;
  final int sessionsCount;

  const SessionCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    this.type = 'recorded',
    this.color,
    this.isActive = true,
    this.sessionsCount = 0,
  });

  /// Factory parser for:
  /// https://awsdemo.co.in/innovateconnect/api/v1/session-categories?type=recorded
  factory SessionCategoryModel.fromJson(Map<String, dynamic> json) {
    return SessionCategoryModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      name: (json['name'] ?? '').toString(),
      slug: (json['slug'] ?? '').toString(),
      type: (json['type'] ?? 'recorded').toString(),
      color: json['color']?.toString(),
      isActive: json['is_active'] == true || json['is_active'] == 1,
      sessionsCount: json['sessions_count'] is int
          ? json['sessions_count'] as int
          : int.tryParse('${json['sessions_count']}') ?? 0,
    );
  }

  static const List<SessionCategoryModel> defaultRecordedCategories = [
    SessionCategoryModel(id: 0, name: 'All Library', slug: 'all-library'),
    SessionCategoryModel(id: 15, name: 'System Design', slug: 'system-design'),
    SessionCategoryModel(id: 10, name: 'Corporate Skills', slug: 'corporate-skills'),
    SessionCategoryModel(id: 14, name: 'Web Development', slug: 'web-development'),
    SessionCategoryModel(id: 13, name: 'Data Science', slug: 'data-science'),
    SessionCategoryModel(id: 9, name: 'Career Strategy', slug: 'career-strategy'),
  ];
}
