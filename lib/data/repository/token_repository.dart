import 'dart:convert';

//import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/token_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenRepository {
  final SharedPreferencesAsync _sharedPreferences = SharedPreferencesAsync();
  final String _tokenKey = 'auth_token';

  Future<void> saveToken(TokenModel token) async {
    final String jsonSring = jsonEncode(token.toJson());
    await _sharedPreferences.setString(_tokenKey, jsonSring);
  }

  Future<TokenModel?> getToken() async {
    final String? rawJson = await _sharedPreferences.getString(_tokenKey);
    if (rawJson == null) {
      return null;
    }

    try {
      final Map<String, dynamic> jsonMap = jsonDecode(rawJson);
      final token = TokenModel.fromJson(jsonMap);
      if (token.isAccessTokenExpired) {
        await removeToken();
        return null;
      }
      return token;
    } catch (e) {
      await removeToken();
    }
    return null;
  }

  Future<void> removeToken() async {
    await _sharedPreferences.remove(_tokenKey);
  }
}
