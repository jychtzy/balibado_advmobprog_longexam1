import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';

/// Handles authentication against the dummyjson.com API
/// (https://dummyjson.com/docs/users) and persists the session
/// using shared_preferences so the [SplashScreen] can decide whether
/// the user is already logged in.
class AuthService {
  /// Logs the user in via POST /user/login and stores the resulting
  /// user + tokens in shared_preferences.
  Future<UserModel> login({
    required String username,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(AppConstants.loginEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final user = UserModel.fromJson(data);
      await _persistSession(user);
      return user;
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Invalid username or password');
    }
  }

  /// Persists the logged-in user + tokens + login flag to shared_preferences.
  Future<void> _persistSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.prefIsLoggedIn, true);
    await prefs.setString(AppConstants.prefUserData, jsonEncode(user.toJson()));
    if (user.accessToken != null) {
      await prefs.setString(AppConstants.prefAccessToken, user.accessToken!);
    }
    if (user.refreshToken != null) {
      await prefs.setString(AppConstants.prefRefreshToken, user.refreshToken!);
    }
  }

  /// Reads the persisted session (if any). Returns null if the user
  /// is not logged in.
  Future<UserModel?> getPersistedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConstants.prefIsLoggedIn) ?? false;
    final userJson = prefs.getString(AppConstants.prefUserData);

    if (isLoggedIn && userJson != null) {
      return UserModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.prefAccessToken);
  }

  /// Clears the persisted session (used by the Sign Out button on the
  /// SettingsScreen).
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefIsLoggedIn);
    await prefs.remove(AppConstants.prefUserData);
    await prefs.remove(AppConstants.prefAccessToken);
    await prefs.remove(AppConstants.prefRefreshToken);
  }
}
