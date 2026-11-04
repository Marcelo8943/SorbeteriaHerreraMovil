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
  bool _isChangingPassword = false;
  bool get isChangingPassword => _isChangingPassword;
  String? _passwordChangeMessage;
  String? get passwordChangeMessage => _passwordChangeMessage;

  Future<void> login({
    required String username,
    required String password,
  }) async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.login(username, password);
      _currentUser = await _authService.getMe();
      _authStatus = AuthStatus.authenticated;
    } on AppException catch (e) {
      _currentUser = null;
      _authStatus = AuthStatus.unauthenticated;
      _errorMessage = e is UnauthorizedException
          ? 'Usuario o contraseña incorrectos.'
          : e.message;
    } on FormatException catch (e) {
      _currentUser = null;
      _authStatus = AuthStatus.unauthenticated;
      _errorMessage = e.message.isNotEmpty
          ? e.message
          : 'El formato de los datos ingresados no es válido.';
    } catch (e) {
      _currentUser = null;
      _authStatus = AuthStatus.unauthenticated;
      _errorMessage = 'Ocurrió un error inesperado. Intenta de nuevo.';
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

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_isChangingPassword) return false;
    _isChangingPassword = true;
    _passwordChangeMessage = null;
    notifyListeners();

    var changed = false;
    try {
      _passwordChangeMessage = await _authService.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      changed = true;
    } on AppException catch (error) {
      _passwordChangeMessage = error.message;
    } catch (error) {
      _passwordChangeMessage = error.toString();
    } finally {
      _isChangingPassword = false;
      notifyListeners();
    }
    return changed;
  }

  Future<void> checkSession() async {
    try {
      final bool isAuthenticated = await _authService.isLoggedIn();
      if (isAuthenticated) {
        _currentUser = await _authService.getMe();
        _authStatus = AuthStatus.authenticated;
      } else {
        _currentUser = null;
        _authStatus = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _currentUser = null;
      _errorMessage = "An unexpected error ocurred. Please try again.";
      _authStatus = AuthStatus.unauthenticated;
    } finally {
      notifyListeners();
    }
  }
}
