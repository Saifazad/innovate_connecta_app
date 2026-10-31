import '../models/certificate_model.dart';

class CertificatesRepository {
  /// Dummy API simulating fetching user's earned certificates
  Future<List<CertificateModel>> fetchCertificates() async {
    // Simulate API network latency
    await Future.delayed(const Duration(milliseconds: 300));
    return CertificateModel.dummyCertificates;
  }

  Future<bool> verifyCertificate(String certificateId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
