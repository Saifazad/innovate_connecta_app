import 'package:flutter/material.dart';

class CertificateModel {
  final String id;
  final String title;
  final String issuer;
  final String type;
  final String issuedDate;
  final String certificateId;
  final bool isValid;
  final bool isVerified;
  final Color sealColor;

  const CertificateModel({
    required this.id,
    required this.title,
    this.issuer = 'Innovate Connect Academy',
    required this.type,
    required this.issuedDate,
    required this.certificateId,
    this.isValid = true,
    this.isVerified = true,
    this.sealColor = const Color(0xFFF59E0B),
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      id: json['id']?.toString() ?? '1',
      title: json['title'] as String? ?? 'Certificate',
      issuer: json['issuer'] as String? ?? 'Innovate Connect Academy',
      type: json['type'] as String? ?? 'Course Completion Certificate',
      issuedDate: json['issued_date'] as String? ?? '12 Aug 2025',
      certificateId: json['certificate_id'] as String? ?? 'ICA-2025-00123',
      isValid: json['is_valid'] as bool? ?? true,
      isVerified: json['is_verified'] as bool? ?? true,
      sealColor: json['seal_color'] != null
          ? Color(json['seal_color'] as int)
          : const Color(0xFFF59E0B),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'issuer': issuer,
      'type': type,
      'issued_date': issuedDate,
      'certificate_id': certificateId,
      'is_valid': isValid,
      'is_verified': isVerified,
    };
  }

  static const List<CertificateModel> dummyCertificates = [
    CertificateModel(
      id: 'cert_001',
      title: 'Python Programming Basics',
      issuer: 'Innovate Connect Academy',
      type: 'Live Session Certificate',
      issuedDate: '12 Aug 2025',
      certificateId: 'ICA-PY-2025-00123',
      isValid: true,
      isVerified: true,
      sealColor: Color(0xFFF59E0B), // Warm Gold
    ),
    CertificateModel(
      id: 'cert_002',
      title: 'Web Development Bootcamp',
      issuer: 'Innovate Connect Academy',
      type: 'Course Completion Certificate',
      issuedDate: '28 Jul 2025',
      certificateId: 'ICA-WEB-2025-00987',
      isValid: true,
      isVerified: true,
      sealColor: Color(0xFF38BDF8), // Cyan / Blue
    ),
  ];
}
