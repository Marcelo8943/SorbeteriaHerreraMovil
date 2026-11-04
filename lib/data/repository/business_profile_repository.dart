import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/business_profile_model.dart';

class BusinessProfileRepository {
  BusinessProfileRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<BusinessProfileModel> getProfile() async {
    final json = await _apiClient.get('/BusinessProfile');

    if (json is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    return BusinessProfileModel.fromJson(json);
  }
}
