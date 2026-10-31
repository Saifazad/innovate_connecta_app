import 'package:flutter/material.dart';
import '../constants/services_strings.dart';

class ServiceItem {
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final List<String> tags;
  final List<String>? benefits;
  final bool isAmberTheme;

  const ServiceItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.tags,
    this.benefits,
    this.isAmberTheme = false,
  });

  static const List<ServiceItem> defaultServices = [
    ServiceItem(
      title: ServicesStrings.careerGuidanceTitle,
      description: ServicesStrings.careerGuidanceDesc,
      icon: Icons.explore_outlined,
      iconColor: Color(0xFFC084FC),
      iconBgColor: Color(0xFF251239),
      tags: [
        ServicesStrings.tagMentorship,
        ServicesStrings.tagMock,
        ServicesStrings.tagGoal,
      ],
      isAmberTheme: false,
    ),
    ServiceItem(
      title: ServicesStrings.upskillingTitle,
      description: ServicesStrings.upskillingDesc,
      icon: Icons.trending_up_rounded,
      iconColor: Color(0xFFC084FC),
      iconBgColor: Color(0xFF251239),
      tags: [ServicesStrings.tagLiveCourses],
      benefits: ServicesStrings.upskillingBenefits,
      isAmberTheme: false,
    ),
    ServiceItem(
      title: ServicesStrings.workshopsTitle,
      description: ServicesStrings.workshopsDesc,
      icon: Icons.handyman_outlined,
      iconColor: Color(0xFFE879F9),
      iconBgColor: Color(0xFF2E102E),
      tags: [
        ServicesStrings.tagSoft,
        ServicesStrings.tagTechnical,
        ServicesStrings.tagLeadership,
      ],
      isAmberTheme: false,
    ),
    ServiceItem(
      title: ServicesStrings.internshipTitle,
      description: ServicesStrings.internshipDesc,
      icon: Icons.work_outline_rounded,
      iconColor: Color(0xFFF59E0B),
      iconBgColor: Color(0xFF281E08),
      tags: [
        ServicesStrings.tagPlacement,
        ServicesStrings.tagTop,
        ServicesStrings.tagStipend,
      ],
      isAmberTheme: true,
    ),
    ServiceItem(
      title: ServicesStrings.corporateTitle,
      description: ServicesStrings.corporateDesc,
      icon: Icons.bar_chart_rounded,
      iconColor: Color(0xFFF59E0B),
      iconBgColor: Color(0xFF281E08),
      tags: [
        ServicesStrings.tagTeamTraining,
        ServicesStrings.tagHrSolutions,
        ServicesStrings.tagCustomPrograms,
      ],
      isAmberTheme: true,
    ),
    ServiceItem(
      title: ServicesStrings.resourcesTitle,
      description: ServicesStrings.resourcesDesc,
      icon: Icons.book_outlined,
      iconColor: Color(0xFFC084FC),
      iconBgColor: Color(0xFF251239),
      tags: [
        ServicesStrings.tagDigitalLibrary,
        ServicesStrings.tagRecordedSessions,
        ServicesStrings.tagTemplates,
      ],
      isAmberTheme: false,
    ),
  ];
}
