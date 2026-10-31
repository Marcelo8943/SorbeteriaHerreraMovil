import 'package:herrera_system/core/constants/regular_expresion.dart';
import 'package:herrera_system/data/models/user_model.dart';
import 'package:herrera_system/data/repository/user_repository.dart';

class UserService {
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<List<UserModel>> getAll() async {
    return await _userRepository.getAll();
  }

  Future<UserModel> getById(int id) async {
    return await _userRepository.getById(id);
  }

  Future<UserModel> createUser(UserModel data) async {
    final json = data.toCreateJson();

    final password = json['password'] as String;
    final userName = json['userName'] as String;
    final email = json['email'] as String;
    final idNumber = json['idNumber'] as String;
    final firstName = json['firstName'] as String;
    final lastName = json['lastName'] as String;
    final roleName = json['roleName'] as String;
    if (password.trim().isEmpty) {
      throw const FormatException('La contraseña es obligatoria.');
    }
    if (!CommonRegex.createUserPasswordRegex.hasMatch(password)) {
      throw const FormatException(
        'Usa una contraseña más segura. Intenta combinar letras, números y símbolos.',
      );
    }
    if (!CommonRegex.emailRegex.hasMatch(userName)) {
      throw const FormatException(
        'El usuario debe tener entre 3 y 50 caracteres.',
      );
    }

    if (!CommonRegex.emailRegex.hasMatch(email)) {
      throw const FormatException(
        'El formato del correo electrónico no es válido',
      );
    }
    if (!CommonRegex.emailRegex.hasMatch(idNumber)) {
      throw const FormatException(
        'La cédula nicaragüense debe tener 13 números seguidos de una letra (Ej: 041221006100F).',
      );
    }
    if (!CommonRegex.emailRegex.hasMatch(firstName)) {
      throw const FormatException('El nombre es obligatorio.');
    }
    if (!CommonRegex.emailRegex.hasMatch(lastName)) {
      throw const FormatException('El apellido es obligatorio.');
    }
    if (!CommonRegex.emailRegex.hasMatch(roleName)) {
      throw const FormatException('El rol es obligatorio.');
    }

    return await _userRepository.createUser(data);
  }

  Future<void> updateUser(int id, UserModel data) async {
    final json = data.toUpdateJson();

    final userName = json['userName'] as String;
    final email = json['email'] as String;
    final idNumber = json['idNumber'] as String;
    final firstName = json['firstName'] as String;
    final lastName = json['lastName'] as String;
    final roleName = json['roleName'] as String;
    if (userName.trim().isEmpty) {
      throw const FormatException('El nombre de usuario es obligatorio.');
    }
    if (!CommonRegex.userNameRegex.hasMatch(userName)) {
      throw const FormatException(
        'El usuario debe tener entre 3 y 50 caracteres.',
      );
    }

    if (email.trim().isEmpty) {
      throw const FormatException('El correo electrónico es obligatorio.');
    }
    if (!CommonRegex.emailRegex.hasMatch(email)) {
      throw const FormatException('El formato del correo no es válido.');
    }

    if (idNumber.trim().isEmpty) {
      throw const FormatException('La cédula es obligatoria.');
    }
    if (!CommonRegex.idNumberRegex.hasMatch(idNumber)) {
      throw const FormatException(
        'La cédula debe tener 13 números y 1 letra (Ej: 041221006100F).',
      );
    }

    if (firstName.trim().isEmpty) {
      throw const FormatException('El nombre es obligatorio.');
    }
    if (lastName.trim().isEmpty) {
      throw const FormatException('El apellido es obligatorio.');
    }
    if (roleName.trim().isEmpty) {
      throw const FormatException('El rol es obligatorio.');
    }

    return await _userRepository.updateUser(id, data);
  }
}
