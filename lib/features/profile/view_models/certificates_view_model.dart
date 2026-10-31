import '../../../core/base/base_view_model.dart';
import '../models/certificate_model.dart';
import '../repository/certificates_repository.dart';

class CertificatesViewModel extends BaseViewModel {
  final CertificatesRepository _repository;

  CertificatesViewModel({CertificatesRepository? repository})
      : _repository = repository ?? CertificatesRepository();

  List<CertificateModel> _certificates = [];

  List<CertificateModel> get certificates => _certificates;
  int get totalCount => _certificates.length;
  int get certificateCount => _certificates.length;

  Future<void> loadCertificates() async {
    setBusy(true);
    try {
      _certificates = await _repository.fetchCertificates();
      clearError();
    } catch (e) {
      setError(e.toString());
    } finally {
      setBusy(false);
    }
  }
}
