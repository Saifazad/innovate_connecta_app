import 'package:flutter/material.dart';

class LiveSessionModel {
  final int id;
  final String title;
  final String? slug;
  final String categoryName;
  final String? categoryColor;
  final String? badgeText;
  final Color? badgeColor;
  final String description;
  final String date;
  final String schedule;
  final String fee;
  final String originalFee;
  final String? imageUrl;
  final String? instructorName;
  final String? instructorDesignation;
  final String? instructorImageUrl;
  final String? registrationUrl;

  /// Convenience getters for UI presentation
  String get dateText => date;
  String get feeText => fee;
  String get originalFeeText => originalFee;

  const LiveSessionModel({
    required this.id,
    required this.title,
    this.slug,
    required this.categoryName,
    this.categoryColor,
    this.badgeText,
    this.badgeColor,
    required this.description,
    required this.date,
    required this.schedule,
    required this.fee,
    required this.originalFee,
    this.imageUrl,
    this.instructorName,
    this.instructorDesignation,
    this.instructorImageUrl,
    this.registrationUrl,
  });

  /// Factory from the API endpoint:
  /// https://awsdemo.co.in/innovateconnect/api/v1/sessions
  factory LiveSessionModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0;
    final title = (json['title'] ?? 'Live Masterclass').toString();
    final slug = json['slug']?.toString();

    // Category
    String catName = 'Masterclass';
    String? catColor;
    if (json['category'] is Map<String, dynamic>) {
      catName = (json['category']['name'] ?? 'Masterclass').toString();
      catColor = json['category']['color']?.toString();
    }

    // Description (strip HTML if present)
    String desc = '';
    if (json['short_description'] != null && json['short_description'].toString().trim().isNotEmpty) {
      desc = stripHtml(json['short_description'].toString());
    } else if (json['section_one_content'] != null) {
      desc = stripHtml(json['section_one_content'].toString());
    } else {
      desc = 'Hands-on interactive masterclass led by industry professionals.';
    }

    // Info cards parsing for Fee, Duration, Schedule
    String parsedFee = '₹99';
    String parsedOriginalFee = '₹199';
    String parsedDate = 'Upcoming';
    String parsedSchedule = 'Weekend Learning';

    final quickSummary = json['quick_summary'];
    if (quickSummary is Map<String, dynamic>) {
      if (quickSummary['session_date'] != null && quickSummary['session_date'].toString().trim().isNotEmpty) {
        parsedDate = quickSummary['session_date'].toString();
      } else if (quickSummary['date_and_time'] != null && quickSummary['date_and_time'].toString().trim().isNotEmpty) {
        parsedDate = quickSummary['date_and_time'].toString();
      }

      if (quickSummary['session_schedule'] != null && quickSummary['session_schedule'].toString().trim().isNotEmpty) {
        parsedSchedule = quickSummary['session_schedule'].toString();
      }

      final feeMap = quickSummary['participation_fee'];
      if (feeMap is Map<String, dynamic>) {
        if (feeMap['price'] != null) parsedFee = feeMap['price'].toString();
        if (feeMap['original_price'] != null) parsedOriginalFee = feeMap['original_price'].toString();
      }
    }

    if (json['info_cards'] is List) {
      final cards = json['info_cards'] as List;
      for (final card in cards) {
        if (card is Map<String, dynamic>) {
          final cTitle = (card['title'] ?? '').toString().toLowerCase();
          if (cTitle.contains('fee') || cTitle.contains('price')) {
            if (card['price'] != null) parsedFee = card['price'].toString();
            if (card['original_price'] != null) parsedOriginalFee = card['original_price'].toString();
          } else if (cTitle.contains('date') || cTitle.contains('duration')) {
            if (card['description'] != null) parsedDate = card['description'].toString();
          } else if (cTitle.contains('schedule') || cTitle.contains('mode')) {
            if (card['description'] != null) parsedSchedule = card['description'].toString();
          }
        }
      }
    }

    // Ensure currency symbol
    if (!parsedFee.startsWith('₹') && !parsedFee.startsWith('Rs')) {
      parsedFee = '₹$parsedFee';
    }
    if (!parsedOriginalFee.startsWith('₹') && !parsedOriginalFee.startsWith('Rs')) {
      parsedOriginalFee = '₹$parsedOriginalFee';
    }

    // Badges based on id or content
    String? badgeText;
    Color? badgeColor;
    if (id % 3 == 0) {
      badgeText = 'Popular';
      badgeColor = const Color(0xFFF59E0B);
    } else if (id % 3 == 1) {
      badgeText = 'Live Soon';
      badgeColor = const Color(0xFFEF4444);
    } else {
      badgeText = 'Recommended';
      badgeColor = const Color(0xFFA855F7);
    }

    // Instructor
    String? instName = json['instructor_name']?.toString();
    String? instDesig = json['instructor_designation']?.toString();
    String? instImg = json['instructor_image_url']?.toString();

    if (json['instructor'] is Map<String, dynamic>) {
      final instMap = json['instructor'] as Map<String, dynamic>;
      instName ??= instMap['name']?.toString();
      instDesig ??= instMap['designation']?.toString();
      instImg ??= instMap['image_url']?.toString();
    }

    return LiveSessionModel(
      id: id,
      title: title,
      slug: slug,
      categoryName: catName,
      categoryColor: catColor,
      badgeText: badgeText,
      badgeColor: badgeColor,
      description: desc,
      date: parsedDate,
      schedule: parsedSchedule,
      fee: parsedFee,
      originalFee: parsedOriginalFee,
      imageUrl: json['image_url']?.toString(),
      instructorName: instName,
      instructorDesignation: instDesig,
      instructorImageUrl: instImg,
      registrationUrl: json['registration_url']?.toString(),
    );
  }

  static String stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Default curated showcase sessions matching the user's design screenshots
  static const List<LiveSessionModel> defaultShowcaseSessions = [
    LiveSessionModel(
      id: 101,
      categoryName: 'CLOUD & DEVOPS',
      badgeText: 'Live Soon',
      badgeColor: Color(0xFFEF4444),
      title: 'Master on Cloud: Cloud & DevOps',
      description:
          'Deploy production scalable cloud infrastructure, Docker containers & CI/CD pipeline automation.',
      date: '10 Oct 2026 (Sat) • 11:00 AM IST',
      schedule: 'Weekend Intensive',
      fee: '₹99',
      originalFee: '₹199',
      instructorName: 'Amir Khan',
      instructorDesignation: 'Cloud Solutions Architect',
    ),
    LiveSessionModel(
      id: 102,
      categoryName: 'System Design',
      badgeText: 'Popular',
      badgeColor: Color(0xFFF59E0B),
      title: 'master on cloud',
      description:
          'Hands-on deep dive into production Kubernetes, Docker microservices, AWS architecture and CI/CD.',
      date: '2 Hours Intensive',
      schedule: 'Weekend Evening',
      fee: '₹100',
      originalFee: '₹999',
      instructorName: 'Kaif Alam',
      instructorDesignation: 'Senior Backend Engineer',
    ),
    LiveSessionModel(
      id: 103,
      categoryName: 'Corporate Skills',
      badgeText: 'Popular',
      badgeColor: Color(0xFFF59E0B),
      title: 'Career Opportunities in IPR & PATENTS',
      description:
          'Ready to take your interest in Intellectual Property Rights & Patents beyond the classroom into corporate careers.',
      date: '5 – 19 September 2026 (15 Days)',
      schedule: 'Weekend Learning',
      fee: '₹99',
      originalFee: '₹199',
      instructorName: 'Ananya Sharma',
      instructorDesignation: 'IP & Patent Specialist',
    ),
    LiveSessionModel(
      id: 104,
      categoryName: 'Career Guidance',
      badgeText: 'Recommended',
      badgeColor: Color(0xFFA855F7),
      title: 'Food Technology Career Roadmap',
      description:
          'Curious about the future of the food industry? Learn quality control, R&D avenues, and food innovation.',
      date: '10 October 2026 (Saturday)',
      schedule: '11:00 AM IST',
      fee: '₹49',
      originalFee: '₹99',
      instructorName: 'Dr. R. K. Verma',
      instructorDesignation: 'Food Scientist & Mentor',
    ),
    LiveSessionModel(
      id: 105,
      categoryName: 'Web Development',
      badgeText: 'Live Soon',
      badgeColor: Color(0xFFEF4444),
      title: 'Full Stack Architecture with MERN & Next.js',
      description:
          'Master building scalable web applications, REST APIs, state management, and real-time backend.',
      date: '12 – 26 October 2026',
      schedule: 'Weekend Sessions (7:00 PM)',
      fee: '₹149',
      originalFee: '₹499',
      instructorName: 'Kaif Alam',
      instructorDesignation: 'Full Stack Web Developer',
    ),
    LiveSessionModel(
      id: 106,
      categoryName: 'System Design & AI',
      badgeText: 'Popular',
      badgeColor: Color(0xFFF59E0B),
      title: 'System Design & Scalable Architecture',
      description:
          'Step into high-load distributed systems, caching patterns, database partitioning, and real-world pipelines.',
      date: '1 – 15 November 2026',
      schedule: 'Weekend Learning',
      fee: '₹199',
      originalFee: '₹699',
      instructorName: 'Kaif Alam',
      instructorDesignation: 'Lead Architect',
    ),
  ];
}
