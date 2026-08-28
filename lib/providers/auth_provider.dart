import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

/// App-wide authentication state, backed by shared_preferences via
/// [AuthService]. The SplashScreen calls [restoreSession] on boot to
/// decide whether to route to HomeScreen or SigninScreen.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Called once from the SplashScreen to check shared_preferences for
  /// an existing session.
  Future<bool> restoreSession() async {
    _currentUser = await _authService.getPersistedUser();
    notifyListeners();
    return isLoggedIn;
  }

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.login(username: username, password: password);
      _currentUser = user;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
