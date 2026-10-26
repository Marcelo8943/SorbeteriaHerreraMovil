import 'dart:convert';

import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/token_model.dart';
import 'package:herrera_system/data/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<TokenModel> login(String username, String password) async {
    final response = await _apiClient.post(
      '/auth/login',
      body: {'username': username, 'password': password},
    );

    if (json is! Map<String, dynamic>) {
      throw ParsingException();
    }

    return TokenModel.fromJson(response);
  }

  Future<UserModel> getMe(String token) async {
    final json = await _apiClient.get('/auth/me');

    if (json == null) throw const UnauthorizedException();
    if (json is! Map<String, dynamic>) {
      throw ParsingException();
    }
    return UserModel.FromJson(json);
  }
}
