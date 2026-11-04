import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/user_model.dart';
import 'package:herrera_system/services/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service;
  UserProvider(this._service);

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  ViewStatus _viewStatus = ViewStatus.initial;
  ViewStatus get viewStatus => _viewStatus;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> getAll() async {
    _viewStatus = ViewStatus.loading;
    notifyListeners();

    try {
      _users = await _service.getAll();
      _viewStatus = ViewStatus.success;
    } catch (e) {
      _errorMessage = e.toString();
      _viewStatus = ViewStatus.error;
    } finally {
      notifyListeners();
    }
  }

  Future<UserModel> getById(int id) => _service.getById(id);
}
