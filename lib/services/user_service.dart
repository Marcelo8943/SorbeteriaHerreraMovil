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
    return await _userRepository.createUser(data);
  }

  Future<void> updateUser(int id, UserModel data) async {
    await _userRepository.updateUser(id, data);
  }
}
