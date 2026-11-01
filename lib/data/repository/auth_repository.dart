import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/token_model.dart';
import 'package:herrera_system/data/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<TokenModel> login(String username, String password) async {
    final json = await _apiClient.post(
      '/auth/login',
      body: {'username': username, 'password': password},
    );

    if (json is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw ParsingException();
    }
    return TokenModel.fromJson(data);
  }

  Future<UserModel> getMe(String token) async {
    final json = await _apiClient.get(
      '/auth/me',
      headers: {'Authorization': 'Bearer $token'},
    );

    if (json is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    return UserModel.fromJson(data);
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final json = await _apiClient.post(
      ApiConstants.changePassword,
      body: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );

    if (json is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    if (json['success'] != true) {
      throw ServerException(
        json['message']?.toString() ?? 'No se pudo cambiar la contraseña.',
      );
    }
    return json['message']?.toString() ?? 'Contraseña actualizada.';
  }
}
