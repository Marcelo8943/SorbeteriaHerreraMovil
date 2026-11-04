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
      const pageSize = 50;
      final firstPage = await _getPage(1, pageSize);
      final users = [...firstPage.users];

      for (var page = 2; page <= firstPage.totalPages; page++) {
        final nextPage = await _getPage(page, pageSize);
        users.addAll(nextPage.users);
      }

      return users;
    } catch (e) {
      throw Exception('Error al obtener usuarios: $e');
    }
  }

  Future<_UsersPage> _getPage(int page, int pageSize) async {
    final response = await _apiClient.get(
      ApiConstants.users,
      query: {'Page': '$page', 'PageSize': '$pageSize'},
    );
    if (response is! Map<String, dynamic>) {
      throw const ParsingException();
    }

    final pageData = response['data'];
    if (pageData is! Map<String, dynamic>) {
      throw const ParsingException();
    }
    final usersData = pageData['data'];
    if (usersData is! List) throw const ParsingException();

    final users = usersData.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const ParsingException();
      }
      return UserModel.fromJson(item);
    }).toList();

    final totalPages = pageData['totalPages'];
    return _UsersPage(
      users: users,
      totalPages: totalPages is int ? totalPages : page,
    );
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

    return UserModel.fromJson(data);
  }

  Future<void> createUser(UserModel data) async {
    await _apiClient.post(
      ApiConstants.users,
      body: data.toCreateJson(),
    );
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

class _UsersPage {
  final List<UserModel> users;
  final int totalPages;

  const _UsersPage({required this.users, required this.totalPages});
}
