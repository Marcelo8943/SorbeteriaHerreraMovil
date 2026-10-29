import 'package:flutter/foundation.dart';
import 'package:herrera_system/core/errors/app_exception.dart';
import 'package:herrera_system/data/models/user_model.dart';
import 'package:herrera_system/services/auth_services.dart';

enum AuthStatus { authenticated, unauthenticated, unknown }

class AuthProvider extends ChangeNotifier {
  final AuthServices _authService;
  AuthProvider(this._authService);

  String? _errorMessage;
  String? get errorMessage => _errorMessage;
  AuthStatus _authStatus = AuthStatus.unknown;
  AuthStatus get authStatus => _authStatus;
  bool get isAuthenticated => _authStatus == AuthStatus.authenticated;
  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    notifyListeners();
    try {
      await _authService.login(username, password);
      _authStatus = AuthStatus.authenticated;
    } on AppException catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
    }

    _isSubmitting = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _authStatus = AuthStatus.unauthenticated;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> checkSession() async {
    try {
      final bool isAuthenticated = await _authService.isLoggedIn();
      _authStatus = isAuthenticated
          ? AuthStatus.authenticated
          : AuthStatus.unauthenticated;
    } catch (e) {
      _errorMessage = "An unexpected error ocurred. Please try again.";
      _authStatus = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }
}
