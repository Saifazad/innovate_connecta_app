import 'package:flutter/material.dart';

class RecordedSessionModel {
  final int id;
  final int? categoryId;
  final String title;
  final String? slug;
  final String categoryName;
  final String? heading;
  final String duration;
  final String lessons;
  final String discountPrice;
  final String originalPrice;
  final double rating;
  final String? thumbnailUrl;
  final String? previewVideoUrl;
  final String? courseOverview;
  final String? whatYouWillLearn;
  final String? instructorName;
  final String? instructorDesignation;
  final String? instructorImageUrl;
  final String? instructorBio;
  final String? instructorExperience;
  final bool isEnrolled;
  final String leftBadge;
  final IconData leftIcon;
  final String rightBadge;
  final IconData rightIcon;

  /// Convenience getters for UI presentation
  String get subtitle => heading ?? courseOverview ?? '';
  String get description => courseOverview ?? heading ?? '';
  String get durationText => duration;
  String get lessonCount => lessons;
  String get feeText => discountPrice;
  String get originalFeeText => originalPrice;

  const RecordedSessionModel({
    required this.id,
    this.categoryId,
    required this.title,
    this.slug,
    required this.categoryName,
    this.heading,
    required this.duration,
    required this.lessons,
    required this.discountPrice,
    required this.originalPrice,
    this.rating = 4.9,
    this.thumbnailUrl,
    this.previewVideoUrl,
    this.courseOverview,
    this.whatYouWillLearn,
    this.instructorName,
    this.instructorDesignation,
    this.instructorImageUrl,
    this.instructorBio,
    this.instructorExperience,
    this.isEnrolled = false,
    this.leftBadge = 'CI / CD',
    this.leftIcon = Icons.code_rounded,
    this.rightBadge = 'DATABASE',
    this.rightIcon = Icons.dns_rounded,
  });

  /// Factory from the API endpoint:
  /// https://awsdemo.co.in/innovateconnect/api/v1/recorded-sessions
  factory RecordedSessionModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0;
    final title = (json['title'] ?? 'Recorded Masterclass').toString();

    // Single non-final definition of slug with smart inference
    String? slug = json['slug']?.toString();
    if (slug == null || slug.trim().isEmpty) {
      if (title.toLowerCase().contains('system') && title.toLowerCase().contains('design')) {
        slug = 'system-design-scalable-architecture';
      } else {
        final gen = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
        if (gen.isNotEmpty) slug = gen;
      }
    }

    // Category
    String catName = 'Self-Paced Course';
    int? catId = json['session_category_id'] is int
        ? json['session_category_id'] as int
        : int.tryParse('${json['session_category_id']}');

    if (json['category'] is Map<String, dynamic>) {
      catName = (json['category']['name'] ?? 'Self-Paced Course').toString();
      catId ??= json['category']['id'] is int
          ? json['category']['id'] as int
          : int.tryParse('${json['category']['id']}');
    } else if (json['category_name'] != null && json['category_name'].toString().trim().isNotEmpty) {
      catName = json['category_name'].toString().trim();
    }

    final heading = json['heading']?.toString() ??
        json['short_description']?.toString() ??
        json['subtitle']?.toString() ??
        json['sub_heading']?.toString() ??
        json['slug_text']?.toString();
    final duration = json['duration'] != null && json['duration'].toString().trim().isNotEmpty
        ? json['duration'].toString()
        : '14 Hours';
    final lessons = json['lessons'] != null && json['lessons'].toString().trim().isNotEmpty
        ? json['lessons'].toString()
        : '18 Lessons';

    String discPrice = '₹3,999';
    String origPrice = '₹4,999';

    if (json['formatted_discount_price'] != null && json['formatted_discount_price'].toString().trim().isNotEmpty) {
      discPrice = json['formatted_discount_price'].toString();
    } else if (json['discount_price'] != null) {
      discPrice = '₹${json['discount_price']}';
    }

    if (json['formatted_original_price'] != null && json['formatted_original_price'].toString().trim().isNotEmpty) {
      origPrice = json['formatted_original_price'].toString();
    } else if (json['original_price'] != null) {
      origPrice = '₹${json['original_price']}';
    }

    if (!discPrice.startsWith('₹') && !discPrice.startsWith('Rs')) discPrice = '₹$discPrice';
    if (!origPrice.startsWith('₹') && !origPrice.startsWith('Rs')) origPrice = '₹$origPrice';

    String? thumb = json['thumbnail_url']?.toString() ??
        json['image_url']?.toString() ??
        json['thumbnail']?.toString() ??
        json['image']?.toString() ??
        json['cover_image']?.toString();
    if (thumb != null && thumb.trim().isNotEmpty) {
      thumb = thumb.trim();
      if (!thumb.startsWith('http')) {
        final cleanPath = thumb.replaceFirst(RegExp(r'^/?storage/'), '').replaceFirst(RegExp(r'^/'), '');
        thumb = 'https://awsdemo.co.in/innovateconnect/storage/$cleanPath';
      }
    } else {
      thumb = null;
    }

    String? instName;
    String? instDesig;
    String? instImg;
    String? instBio;
    String? instExp;
    if (json['instructor'] is Map<String, dynamic>) {
      final instMap = json['instructor'] as Map<String, dynamic>;
      instName = instMap['name']?.toString();
      instDesig = instMap['designation']?.toString();
      instImg = instMap['image_url']?.toString();
      if (instImg == null || instImg.isEmpty) {
        if (instMap['image'] != null && instMap['image'].toString().isNotEmpty) {
          final img = instMap['image'].toString();
          instImg = img.startsWith('http') ? img : 'https://awsdemo.co.in/innovateconnect/storage/$img';
        }
      }
      instBio = instMap['bio']?.toString();
      instExp = instMap['experience']?.toString();
    }

    final isEnrolled = json['is_enrolled'] == true || json['is_enrolled'] == 1 || json['is_enrolled'] == '1';

    // Technology decorative badges depending on title/category
    final lowerTitle = title.toLowerCase();
    String lBadge = 'TECH';
    IconData lIcon = Icons.terminal_rounded;
    String rBadge = 'CLOUD';
    IconData rIcon = Icons.cloud_queue_rounded;

    if (lowerTitle.contains('system') || lowerTitle.contains('scalab')) {
      lBadge = 'CI / CD';
      lIcon = Icons.code_rounded;
      rBadge = 'DATABASE';
      rIcon = Icons.dns_rounded;
    } else if (lowerTitle.contains('mern') || lowerTitle.contains('web') || lowerTitle.contains('full stack')) {
      lBadge = 'REACT';
      lIcon = Icons.developer_mode_rounded;
      rBadge = 'NEXT.JS';
      rIcon = Icons.language_rounded;
    } else if (lowerTitle.contains('patent') || lowerTitle.contains('ipr') || lowerTitle.contains('legal')) {
      lBadge = 'PATENT';
      lIcon = Icons.security_rounded;
      rBadge = 'IPR LAW';
      rIcon = Icons.menu_book_rounded;
    } else if (lowerTitle.contains('data') || lowerTitle.contains('python') || lowerTitle.contains('machine')) {
      lBadge = 'PYTORCH';
      lIcon = Icons.bolt_rounded;
      rBadge = 'MLOPS';
      rIcon = Icons.cloud_done_rounded;
    } else if (lowerTitle.contains('career') || lowerTitle.contains('interview')) {
      lBadge = 'RESUME';
      lIcon = Icons.description_rounded;
      rBadge = 'OFFERS';
      rIcon = Icons.work_outline_rounded;
    }

    return RecordedSessionModel(
      id: id,
      categoryId: catId,
      title: title,
      slug: slug,
      categoryName: catName,
      heading: heading,
      duration: duration,
      lessons: lessons,
      discountPrice: discPrice,
      originalPrice: origPrice,
      rating: 4.9,
      thumbnailUrl: thumb,
      previewVideoUrl: json['preview_video_url']?.toString(),
      courseOverview: json['course_overview'] != null ? stripHtml(json['course_overview'].toString()) : null,
      whatYouWillLearn: json['what_you_will_learn'] != null ? stripHtml(json['what_you_will_learn'].toString()) : null,
      instructorName: instName,
      instructorDesignation: instDesig,
      instructorImageUrl: instImg,
      instructorBio: instBio,
      instructorExperience: instExp,
      isEnrolled: isEnrolled,
      leftBadge: lBadge,
      leftIcon: lIcon,
      rightBadge: rBadge,
      rightIcon: rIcon,
    );
  }

  /// Factory for dynamic mapping from sessions API when category type is recorded
  factory RecordedSessionModel.fromSessionJson(Map<String, dynamic> json) {
    final id = json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0;
    final title = (json['title'] ?? 'Recorded Masterclass').toString();

    // Single non-final definition of slug with smart inference
    String? slug = json['slug']?.toString();
    if (slug == null || slug.trim().isEmpty) {
      if (title.toLowerCase().contains('system') && title.toLowerCase().contains('design')) {
        slug = 'system-design-scalable-architecture';
      } else {
        final gen = title.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-').replaceAll(RegExp(r'^-+|-+$'), '');
        if (gen.isNotEmpty) slug = gen;
      }
    }

    String catName = 'Self-Paced Course';
    int? catId = json['session_category_id'] is int
        ? json['session_category_id'] as int
        : int.tryParse('${json['session_category_id']}');

    if (json['category'] is Map<String, dynamic>) {
      catName = (json['category']['name'] ?? 'Self-Paced Course').toString();
      catId ??= json['category']['id'] is int
          ? json['category']['id'] as int
          : int.tryParse('${json['category']['id']}');
    } else if (json['category_name'] != null && json['category_name'].toString().trim().isNotEmpty) {
      catName = json['category_name'].toString().trim();
    }

    String heading = '';
    if (json['short_description'] != null && json['short_description'].toString().trim().isNotEmpty) {
      heading = stripHtml(json['short_description'].toString());
    } else if (json['section_one_content'] != null) {
      heading = stripHtml(json['section_one_content'].toString());
    } else if (json['heading'] != null) {
      heading = stripHtml(json['heading'].toString());
    }

    String duration = '2 Hours';
    String lessons = 'Full Access';
    String discPrice = '₹99';
    String origPrice = '₹199';

    if (json['info_cards'] is List) {
      for (final card in json['info_cards']) {
        if (card is Map<String, dynamic>) {
          final cTitle = (card['title'] ?? '').toString().toLowerCase();
          if (cTitle.contains('fee') || cTitle.contains('price')) {
            if (card['price'] != null) discPrice = card['price'].toString();
            if (card['original_price'] != null) origPrice = card['original_price'].toString();
          } else if (cTitle.contains('duration')) {
            if (card['description'] != null) duration = card['description'].toString();
          }
        }
      }
    }

    final quickSummary = json['quick_summary'];
    if (quickSummary is Map<String, dynamic>) {
      if (quickSummary['date_and_time'] != null) duration = quickSummary['date_and_time'].toString();
      final feeMap = quickSummary['participation_fee'];
      if (feeMap is Map<String, dynamic>) {
        if (feeMap['price'] != null) discPrice = feeMap['price'].toString();
        if (feeMap['original_price'] != null) origPrice = feeMap['original_price'].toString();
      }
    }

    if (json['formatted_discount_price'] != null && json['formatted_discount_price'].toString().trim().isNotEmpty) {
      discPrice = json['formatted_discount_price'].toString();
    } else if (json['discount_price'] != null) {
      discPrice = '₹${json['discount_price']}';
    }

    if (json['formatted_original_price'] != null && json['formatted_original_price'].toString().trim().isNotEmpty) {
      origPrice = json['formatted_original_price'].toString();
    } else if (json['original_price'] != null) {
      origPrice = '₹${json['original_price']}';
    }

    if (!discPrice.startsWith('₹') && !discPrice.startsWith('Rs')) discPrice = '₹$discPrice';
    if (!origPrice.startsWith('₹') && !origPrice.startsWith('Rs')) origPrice = '₹$origPrice';

    String? instName = json['instructor_name']?.toString();
    String? instDesig = json['instructor_designation']?.toString();
    String? instImg = json['instructor_image_url']?.toString();
    String? instBio;
    String? instExp;

    if (json['instructor'] is Map<String, dynamic>) {
      final instMap = json['instructor'] as Map<String, dynamic>;
      instName ??= instMap['name']?.toString();
      instDesig ??= instMap['designation']?.toString();
      instImg ??= instMap['image_url']?.toString();
      if (instImg == null || instImg.isEmpty) {
        if (instMap['image'] != null && instMap['image'].toString().isNotEmpty) {
          final img = instMap['image'].toString();
          instImg = img.startsWith('http') ? img : 'https://awsdemo.co.in/innovateconnect/storage/$img';
        }
      }
      instBio = instMap['bio']?.toString();
      instExp = instMap['experience']?.toString();
    }

    String? thumb = json['thumbnail_url']?.toString() ??
        json['image_url']?.toString() ??
        json['thumbnail']?.toString() ??
        json['image']?.toString() ??
        json['cover_image']?.toString();
    if (thumb != null && thumb.trim().isNotEmpty) {
      thumb = thumb.trim();
      if (!thumb.startsWith('http')) {
        final cleanPath = thumb.replaceFirst(RegExp(r'^/?storage/'), '').replaceFirst(RegExp(r'^/'), '');
        thumb = 'https://awsdemo.co.in/innovateconnect/storage/$cleanPath';
      }
    } else {
      thumb = null;
    }

    final lowerTitle = title.toLowerCase();
    String lBadge = 'WEB';
    IconData lIcon = Icons.language_rounded;
    String rBadge = 'DEV';
    IconData rIcon = Icons.code_rounded;

    if (lowerTitle.contains('python') || lowerTitle.contains('stack')) {
      lBadge = 'PYTHON';
      lIcon = Icons.terminal_rounded;
      rBadge = 'FULL STACK';
      rIcon = Icons.layers_rounded;
    } else if (lowerTitle.contains('ipr') || lowerTitle.contains('patent')) {
      lBadge = 'PATENT';
      lIcon = Icons.shield_outlined;
      rBadge = 'IPR LAW';
      rIcon = Icons.menu_book_rounded;
    } else if (lowerTitle.contains('cloud')) {
      lBadge = 'AWS';
      lIcon = Icons.cloud_queue_rounded;
      rBadge = 'DEVOPS';
      rIcon = Icons.all_inclusive_rounded;
    }

    return RecordedSessionModel(
      id: id,
      categoryId: catId,
      title: title,
      slug: slug,
      categoryName: catName,
      heading: heading.isNotEmpty ? heading : null,
      duration: duration,
      lessons: lessons,
      discountPrice: discPrice,
      originalPrice: origPrice,
      rating: 4.9,
      thumbnailUrl: thumb,
      previewVideoUrl: json['preview_video_url']?.toString() ?? json['video_url']?.toString(),
      courseOverview: json['course_overview'] != null
          ? stripHtml(json['course_overview'].toString())
          : (json['description'] != null ? stripHtml(json['description'].toString()) : null),
      whatYouWillLearn: json['what_you_will_learn'] != null
          ? stripHtml(json['what_you_will_learn'].toString())
          : null,
      instructorName: instName,
      instructorDesignation: instDesig,
      instructorImageUrl: instImg,
      instructorBio: instBio,
      instructorExperience: instExp,
      isEnrolled: json['is_enrolled'] == true || json['is_enrolled'] == 1 || json['is_enrolled'] == '1',
      leftBadge: lBadge,
      leftIcon: lIcon,
      rightBadge: rBadge,
      rightIcon: rIcon,
    );
  }

  static String stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'</p>\s*<p>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</li>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'[ \t]+'), ' ')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }

  /// Formats whatYouWillLearn string into clean bullet points
  List<String> get learningPoints {
    if (whatYouWillLearn == null || whatYouWillLearn!.trim().isEmpty) {
      return [
        'Gain deep foundational knowledge and practical skills.',
        'Real-world architecture and industry-standard best practices.',
        'Hands-on exercises and production-ready implementations.',
        'Lifetime access to course updates and curriculum resources.',
      ];
    }
    final raw = whatYouWillLearn!
        .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</li>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<p\s*/?>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'</p>', caseSensitive: false), '\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");
    final points = raw
        .split(RegExp(r'[\r\n]+'))
        .map((s) => s.replaceAll(RegExp(r'^[•\-\*]\s*'), '').replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((s) => s.isNotEmpty && s.length > 3)
        .toList();
    if (points.isEmpty) {
      return [
        'Gain deep foundational knowledge and practical skills.',
        'Real-world architecture and industry-standard best practices.',
        'Hands-on exercises and production-ready implementations.',
      ];
    }
    return points;
  }

  RecordedSessionModel copyWith({
    int? id,
    int? categoryId,
    String? title,
    String? slug,
    String? categoryName,
    String? heading,
    String? duration,
    String? lessons,
    String? discountPrice,
    String? originalPrice,
    double? rating,
    String? thumbnailUrl,
    String? previewVideoUrl,
    String? courseOverview,
    String? whatYouWillLearn,
    String? instructorName,
    String? instructorDesignation,
    String? instructorImageUrl,
    String? instructorBio,
    String? instructorExperience,
    bool? isEnrolled,
    String? leftBadge,
    IconData? leftIcon,
    String? rightBadge,
    IconData? rightIcon,
  }) {
    return RecordedSessionModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      slug: slug ?? this.slug,
      categoryName: categoryName ?? this.categoryName,
      heading: heading ?? this.heading,
      duration: duration ?? this.duration,
      lessons: lessons ?? this.lessons,
      discountPrice: discountPrice ?? this.discountPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      previewVideoUrl: previewVideoUrl ?? this.previewVideoUrl,
      courseOverview: courseOverview ?? this.courseOverview,
      whatYouWillLearn: whatYouWillLearn ?? this.whatYouWillLearn,
      instructorName: instructorName ?? this.instructorName,
      instructorDesignation: instructorDesignation ?? this.instructorDesignation,
      instructorImageUrl: instructorImageUrl ?? this.instructorImageUrl,
      instructorBio: instructorBio ?? this.instructorBio,
      instructorExperience: instructorExperience ?? this.instructorExperience,
      isEnrolled: isEnrolled ?? this.isEnrolled,
      leftBadge: leftBadge ?? this.leftBadge,
      leftIcon: leftIcon ?? this.leftIcon,
      rightBadge: rightBadge ?? this.rightBadge,
      rightIcon: rightIcon ?? this.rightIcon,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_category_id': categoryId,
      'title': title,
      'slug': slug,
      'category_name': categoryName,
      'heading': heading,
      'duration': duration,
      'lessons': lessons,
      'discount_price': discountPrice,
      'original_price': originalPrice,
      'rating': rating,
      'thumbnail_url': thumbnailUrl,
      'preview_video_url': previewVideoUrl,
      'course_overview': courseOverview,
      'what_you_will_learn': whatYouWillLearn,
      'instructor_name': instructorName,
      'instructor_designation': instructorDesignation,
      'instructor_image_url': instructorImageUrl,
      'instructor_bio': instructorBio,
      'instructor_experience': instructorExperience,
      'is_enrolled': isEnrolled,
    };
  }
}
