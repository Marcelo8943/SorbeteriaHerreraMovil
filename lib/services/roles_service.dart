import 'package:herrera_system/data/models/roles_model.dart';
import 'package:herrera_system/data/repository/roles_repository.dart';

class RoleService {
  final RolesRepository _roleRepository;

  RoleService(this._roleRepository);

  Future<List<RolesModel>> getAll() => _roleRepository.getAll();
}
