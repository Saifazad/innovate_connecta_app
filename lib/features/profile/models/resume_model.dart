class ResumeModel {
  final String id;
  final String fileName;
  final String? filePath;
  final String fileSize;
  final String title;
  final String uploadedAt;
  final bool isVerified;
  final bool isAtsReady;

  const ResumeModel({
    required this.id,
    required this.fileName,
    this.filePath,
    required this.fileSize,
    required this.title,
    required this.uploadedAt,
    this.isVerified = true,
    this.isAtsReady = true,
  });

  factory ResumeModel.fromJson(Map<String, dynamic> json) {
    return ResumeModel(
      id: json['id'] as String? ?? 'res_001',
      fileName: json['file_name'] as String? ?? 'Resume.pdf',
      filePath: json['file_path'] as String?,
      fileSize: json['file_size'] as String? ?? '1.4 MB',
      title: json['title'] as String? ?? 'Resume',
      uploadedAt: json['uploaded_at'] as String? ?? 'Uploaded on 22 Oct 2026',
      isVerified: json['is_verified'] as bool? ?? true,
      isAtsReady: json['is_ats_ready'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      'file_size': fileSize,
      'title': title,
      'uploaded_at': uploadedAt,
      'is_verified': isVerified,
      'is_ats_ready': isAtsReady,
    };
  }

  static const ResumeModel defaultActiveResume = ResumeModel(
    id: 'res_001',
    fileName: 'Resume.pdf',
    fileSize: '1.4 MB',
    title: 'Resume',
    uploadedAt: 'Uploaded on 22 Oct 2026',
    isVerified: true,
    isAtsReady: true,
  );
}
