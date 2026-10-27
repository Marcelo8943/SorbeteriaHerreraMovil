import 'package:herrera_system/data/models/business_profile_model.dart';
import 'package:herrera_system/data/repository/business_profile_repository.dart';

class BusinessProfileService {
  BusinessProfileService(this._repository);

  final BusinessProfileRepository _repository;

  Future<BusinessProfileModel> getProfile() => _repository.getProfile();
}
