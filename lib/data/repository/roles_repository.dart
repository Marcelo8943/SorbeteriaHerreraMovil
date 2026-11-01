import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/roles_model.dart';

class RolesRepository {
  final ApiClient _apiClient;

  RolesRepository(this._apiClient);

  Future<List<RolesModel>> getAll() async {
    final response = await _apiClient.get(ApiConstants.roles);
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    final data = response['data'];
    if (data is! List) throw const ParsingException();

    return data.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const ParsingException();
      }
      return RolesModel.fromJson(item);
    }).toList();
  }
}
