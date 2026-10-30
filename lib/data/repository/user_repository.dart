import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/api_constants.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/core/network/api_client.dart';
import 'package:herrera_system/data/models/user_model.dart';

class UserRepository {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  /// Obtiene todos los usuarios
  Future<List<UserModel>> getAll() async {
    try {
      // Llamada a la API
      final data = await _apiClient.get('/users');

      if (data != null && data is List) {
        // Mapeo de cada elemento a UserModel
        return data.map((item) => UserModel.fromJson(item)).toList();
      } else {
        return [];
      }
    } catch (e) {
      // Manejo de errores
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  Future<UserModel> getById(int id) async {
    final json = await _apiClient.get('${ApiConstants.users}/$id');

    if (json is! Map<String, dynamic>) {
      throw ParsingException();
    }

    final data = json['data'];
    if (data is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    return UserModel.fromJson(json);
  }

  Future<UserModel> createUser(UserModel data) async {
    final json = await _apiClient.post(
      ApiConstants.users,
      body: data.toCreateJson(),
    );
    if (json is! Map<String, dynamic>) throw ParsingException();

    return UserModel.fromJson(json);
  }

  Future<void> updateUser(int id, UserModel data) async {
    await _apiClient.put(
      '${ApiConstants.users}/$id',
      body: data.toUpdateJson(),
    );
  }

  Future<UserModel> toggleUser(int id) async {
    final json = await _apiClient.patch(
      '${ApiConstants.users}/$id/toggle-status',
    );

    if (json is! Map<String, dynamic> ||
        json['data'] is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    return UserModel.fromJson(json);
  }
}
