import 'package:flutter/material.dart';
import 'package:herrera_system/data/models/user_model.dart';
import 'package:herrera_system/services/user_service.dart';

enum ViewStatus { initial, loading, succes, error }

class UserProvider extends ChangeNotifier {
  final UserService _service;
  UserProvider(this._service);

  final List<UserModel> _users = [];
  List<UserModel> get users => _users;

  ViewStatus _viewStatus = ViewStatus.initial;
  ViewStatus get viewStatus => _viewStatus;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
}
