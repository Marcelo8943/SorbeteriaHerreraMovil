import 'package:herrera_system/core/constants/regular_expresion.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/token_model.dart';
import 'package:herrera_system/data/models/user_model.dart';
import 'package:herrera_system/data/repository/auth_repository.dart';
import 'package:herrera_system/data/repository/token_repository.dart';

class AuthServices {
  final AuthRepository _authRepository;
  final TokenRepository _tokenRepository;

  AuthServices(this._authRepository, this._tokenRepository);

  Future<void> login(String username, String password) async {
    final trimemUsername = username.trim();
    final trimmedPassword = password.trim();

    if (trimemUsername.isEmpty || trimmedPassword.isEmpty) {
      throw const FormatException('Usuario y contraseña no puede estar vacio');
    }

    if (!CommonRegex.userNameRegex.hasMatch(trimemUsername)) {
      throw const FormatException('Formato de usuario invalido');
    }
    if (!CommonRegex.passwordRegex.hasMatch(trimmedPassword)) {
      throw const FormatException('Formato de contraseña invalido');
    }
    final TokenModel token = await _authRepository.login(username, password);
    await _tokenRepository.saveToken(token);
  }

  Future<UserModel> getMe() async {
    final token = await _tokenRepository.getToken();
    if (token == null) {
      throw const UnauthorizedException();
    }

    return _authRepository.getMe(token.token);
  }

  Future<String> changePassword({
    required String currentPassword,
    required String newPassword,
  }) {
    return _authRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  Future<bool> isLoggedIn() => _tokenRepository.hasValidToken();
  Future<void> logout() => _tokenRepository.removeToken();
}
