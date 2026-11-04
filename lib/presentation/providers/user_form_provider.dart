import 'package:flutter/material.dart';
import 'package:herrera_system/core/constants/view_status.dart';
import 'package:herrera_system/data/models/user_model.dart';
import 'package:herrera_system/services/user_service.dart';

class UserFormProvider extends ChangeNotifier {
  final UserService _userService;

  UserFormProvider(this._userService);

  ViewStatus _status = ViewStatus.initial;
  ViewStatus get status => _status;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> createUser(UserModel user) async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.createUser(user);
      _status = ViewStatus.success;
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      _status = ViewStatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> updateUser(int id, UserModel user) async {
    _status = ViewStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      await _userService.updateUser(id, user);
      _status = ViewStatus.success;
      return true;
    } catch (error) {
      _errorMessage = error.toString();
      _status = ViewStatus.error;
      return false;
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _status = ViewStatus.initial;
    _errorMessage = null;
    notifyListeners();
  }
}
