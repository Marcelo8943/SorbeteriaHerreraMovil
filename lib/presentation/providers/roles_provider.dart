import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/roles_model.dart';
import 'package:herrera_system/services/roles_service.dart';

class RolesProvider extends ChangeNotifier {
  final RoleService _roleService;

  RolesProvider(this._roleService);

  List<RolesModel> _roles = [];
  List<RolesModel> get roles => _roles;

  ViewStatus _status = ViewStatus.initial;
  ViewStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> loadRoles() async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _roles = await _roleService.getAll();
      _status = ViewStatus.success;
    } catch (error) {
      _errorMessage = error.toString();
      _status = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
