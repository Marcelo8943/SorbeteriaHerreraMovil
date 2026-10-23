import 'package:herrera_system/core/constants/regular_expresion.dart';
import 'package:herrera_system/data/models/token_model.dart';
import 'package:herrera_system/data/models/user_model.dart';
import 'package:herrera_system/data/repository/auth_repository.dart';

class AuthServices {
  final AuthRepository _authRepository;

  AuthServices(this._authRepository);

  Future<TokenModel> login(String username, String password) async {
    final trimemUsername = username.trim();
    final trimmedPassword = password.trim();

    if (trimemUsername.isEmpty || trimmedPassword.isEmpty) {
      throw const FormatException('Username and password cannot be empty');
    }

    if (CommonRegex.emailRegex.hasMatch(trimemUsername)) {
      throw const FormatException('Invalid email format');
    }
    if (!CommonRegex.passwordRegex.hasMatch(trimmedPassword)) {
      throw const FormatException('Invalid password format');
    }
    final TokenModel token = await _authRepository.login(username, password);
    return token;
  }

  Future<UserModel> getMe(String token) async {
    return await _authRepository.getMe(token);
  }
}
