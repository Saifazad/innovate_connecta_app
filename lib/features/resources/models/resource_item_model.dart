class ResourceItemModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String fileType;
  final String fileSize;
  final String downloadUrl;
  final String updatedAt;
  final bool isFeatured;

  const ResourceItemModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.fileType,
    required this.fileSize,
    required this.downloadUrl,
    required this.updatedAt,
    this.isFeatured = false,
  });

  /// 8 Curated resources matching the 8 Files count shown on Dashboard
  static const List<ResourceItemModel> defaultResources = [
    ResourceItemModel(
      id: 'res_001',
      title: 'Complete System Design Masterclass Notes & Diagrams',
      category: 'Architecture',
      description:
          'Comprehensive notes on scalability, load balancing, caching, database sharding, and real-time distributed systems.',
      fileType: 'PDF',
      fileSize: '8.4 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/system-design-notes.pdf',
      updatedAt: 'Updated Oct 2026',
      isFeatured: true,
    ),
    ResourceItemModel(
      id: 'res_002',
      title: 'Microservices Architecture Patterns Guide',
      category: 'Architecture',
      description:
          'Design patterns for service discovery, API gateways, event-driven architecture, and circuit breaker patterns.',
      fileType: 'PDF',
      fileSize: '5.1 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/microservices-guide.pdf',
      updatedAt: 'Updated Sep 2026',
      isFeatured: true,
    ),
    ResourceItemModel(
      id: 'res_003',
      title: 'Docker & Kubernetes Production Cheat Sheet',
      category: 'DevOps & Cloud',
      description:
          'Essential CLI commands, Pod specs, deployment strategies, Helm charts, and cluster debugging tips.',
      fileType: 'PDF',
      fileSize: '2.7 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/k8s-cheat-sheet.pdf',
      updatedAt: 'Updated Oct 2026',
    ),
    ResourceItemModel(
      id: 'res_004',
      title: 'Cloud Engineering & AWS Solutions Architect Handbook',
      category: 'DevOps & Cloud',
      description:
          'High-availability architectures on AWS: VPC, IAM, EC2, S3, RDS, Lambda, and cost optimization techniques.',
      fileType: 'PDF',
      fileSize: '6.3 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/aws-architect-handbook.pdf',
      updatedAt: 'Updated Aug 2026',
    ),
    ResourceItemModel(
      id: 'res_005',
      title: 'Full-Stack Interview Preparation Roadmaps',
      category: 'Interview Prep',
      description:
          'Step-by-step roadmap covering DSA patterns, system design, frontend optimization, and mock interview checklists.',
      fileType: 'PDF',
      fileSize: '3.8 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/interview-roadmap.pdf',
      updatedAt: 'Updated Oct 2026',
    ),
    ResourceItemModel(
      id: 'res_006',
      title: 'Data Structures & Algorithms Problem Patterns',
      category: 'Interview Prep',
      description:
          'Top 14 algorithmic patterns: Two Pointers, Sliding Window, Fast & Slow Pointers, DFS, BFS, and Dynamic Programming.',
      fileType: 'PDF',
      fileSize: '4.5 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/dsa-patterns.pdf',
      updatedAt: 'Updated Sep 2026',
    ),
    ResourceItemModel(
      id: 'res_007',
      title: 'High-Impact Tech Resume & Portfolio Template',
      category: 'Career',
      description:
          'ATS-friendly modern engineering resume templates and guidelines to pass technical screenings.',
      fileType: 'DOCX',
      fileSize: '1.2 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/tech-resume-template.docx',
      updatedAt: 'Updated Oct 2026',
    ),
    ResourceItemModel(
      id: 'res_008',
      title: 'IPR, Patents & Corporate Skills Study Kit',
      category: 'Career',
      description:
          'Legal frameworks, patent filing processes, intellectual property fundamentals, and corporate communication skills.',
      fileType: 'PDF',
      fileSize: '3.1 MB',
      downloadUrl: 'https://awsdemo.co.in/resources/ipr-patent-guide.pdf',
      updatedAt: 'Updated Sep 2026',
    ),
  ];
}

