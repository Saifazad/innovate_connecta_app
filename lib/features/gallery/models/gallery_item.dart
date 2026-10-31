import 'package:flutter/material.dart';

class GalleryCategory {
  final int id;
  final String name;
  final String slug;
  final bool isActive;
  final int? galleriesCount;

  const GalleryCategory({
    required this.id,
    required this.name,
    required this.slug,
    this.isActive = true,
    this.galleriesCount,
  });

  factory GalleryCategory.fromJson(Map<String, dynamic> json) {
    return GalleryCategory(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      galleriesCount: json['galleries_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'is_active': isActive,
      if (galleriesCount != null) 'galleries_count': galleriesCount,
    };
  }
}

class GalleryItem {
  final int id;
  final int galleryCategoryId;
  final String title;
  final String? location;
  final String? image;
  final String imageUrl;
  final bool isActive;
  final String? createdAt;
  final String? updatedAt;
  final GalleryCategory? category;

  const GalleryItem({
    required this.id,
    required this.galleryCategoryId,
    required this.title,
    this.location,
    this.image,
    required this.imageUrl,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.category,
  });

  String get categoryName => category?.name ?? 'Event';

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    GalleryCategory? cat;
    if (json['category'] is Map<String, dynamic>) {
      cat = GalleryCategory.fromJson(json['category'] as Map<String, dynamic>);
    }

    String imgUrl = json['image_url'] as String? ?? '';
    // Ensure fallback if image_url is empty but image filename is provided
    if (imgUrl.isEmpty && json['image'] != null && (json['image'] as String).isNotEmpty) {
      imgUrl = 'https://awsdemo.co.in/innovateconnect/storage/${json['image']}';
    }

    return GalleryItem(
      id: json['id'] as int? ?? 0,
      galleryCategoryId: json['gallery_category_id'] as int? ?? (cat?.id ?? 0),
      title: json['title'] as String? ?? '',
      location: json['location'] as String?,
      image: json['image'] as String?,
      imageUrl: imgUrl,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      category: cat,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gallery_category_id': galleryCategoryId,
      'title': title,
      'location': location,
      'image': image,
      'image_url': imageUrl,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (category != null) 'category': category!.toJson(),
    };
  }

  /// Badge colors tailored to match the screenshot UI
  Color get badgeTextColor {
    final lower = (category?.name ?? title).toLowerCase();
    if (lower.contains('workshop')) {
      return const Color(0xFFFBBF24); // Warm Amber
    } else if (lower.contains('campus') || lower.contains('drive')) {
      return const Color(0xFFFB923C); // Warm Peach / Orange
    } else if (lower.contains('interactive') || lower.contains('mentor')) {
      return const Color(0xFFE879F9); // Lavender / Magenta
    } else if (lower.contains('hackathon')) {
      return const Color(0xFF2DD4BF); // Teal
    } else if (lower.contains('networking') || lower.contains('leadership') || lower.contains('summit')) {
      return const Color(0xFF60A5FA); // Sky Blue
    } else if (lower.contains('bootcamp') || lower.contains('masterclass')) {
      return const Color(0xFF34D399); // Emerald Green
    }
    return const Color(0xFFA78BFA); // Soft Violet
  }

  Color get badgeBgColor {
    return badgeTextColor.withValues(alpha: 0.22);
  }

  Color get badgeBorderColor {
    return badgeTextColor.withValues(alpha: 0.45);
  }

  /// Default curated showcase items matching the mockup UI perfectly
  static const List<GalleryItem> defaultShowcaseItems = [
    GalleryItem(
      id: 101,
      galleryCategoryId: 1,
      title: 'Hands-on tech bootcamps',
      location: 'Tech Hub, Bangalore',
      imageUrl: 'https://images.unsplash.com/photo-1531482615713-2afd69097998?auto=format&fit=crop&w=800&q=80',
      category: GalleryCategory(id: 1, name: 'Workshop', slug: 'workshop'),
    ),
    GalleryItem(
      id: 102,
      galleryCategoryId: 2,
      title: 'Campus recruitment drives',
      location: 'Delhi NCR Campus',
      imageUrl: 'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&w=800&q=80',
      category: GalleryCategory(id: 2, name: 'Campus Drive', slug: 'campus-drive'),
    ),
    GalleryItem(
      id: 103,
      galleryCategoryId: 3,
      title: 'Interactive mentor sessions',
      location: 'Innovation Lab',
      imageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=800&q=80',
      category: GalleryCategory(id: 3, name: 'Interactive', slug: 'interactive'),
    ),
    GalleryItem(
      id: 104,
      galleryCategoryId: 4,
      title: 'Annual Student Hackathon',
      location: 'Convention Center',
      imageUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?auto=format&fit=crop&w=800&q=80',
      category: GalleryCategory(id: 4, name: 'Hackathon', slug: 'hackathon'),
    ),
    GalleryItem(
      id: 105,
      galleryCategoryId: 5,
      title: 'Corporate Leadership Meetup',
      location: 'Summit Auditorium',
      imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=800&q=80',
      category: GalleryCategory(id: 5, name: 'Networking', slug: 'networking'),
    ),
    GalleryItem(
      id: 106,
      galleryCategoryId: 6,
      title: 'AI & Full Stack Masterclass',
      location: 'Auditorium Hall',
      imageUrl: 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?auto=format&fit=crop&w=800&q=80',
      category: GalleryCategory(id: 6, name: 'Bootcamp', slug: 'bootcamp'),
    ),
  ];
}

class GalleriesResponse {
  final bool status;
  final String message;
  final List<GalleryItem> data;

  const GalleriesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GalleriesResponse.fromJson(Map<String, dynamic> json) {
    List<GalleryItem> items = [];
    if (json['data'] is List) {
      items = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => GalleryItem.fromJson(e))
          .toList();
    }
    return GalleriesResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: items,
    );
  }
}

class GalleryCategoriesResponse {
  final bool status;
  final String message;
  final List<GalleryCategory> data;

  const GalleryCategoriesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GalleryCategoriesResponse.fromJson(Map<String, dynamic> json) {
    List<GalleryCategory> categories = [];
    if (json['data'] is List) {
      categories = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => GalleryCategory.fromJson(e))
          .toList();
    }
    return GalleryCategoriesResponse(
      status: json['status'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: categories,
    );
  }
}
