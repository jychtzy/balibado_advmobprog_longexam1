import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------
/// App-wide constants
/// ---------------------------------------------------------------------
class AppConstants {
  AppConstants._();

  // Host / API -----------------------------------------------------------
  static const String baseUrl = 'https://dummyjson.com';

  // Auth
  static const String loginEndpoint = 'https://dummyjson.com/auth/login';
  static const String authMeEndpoint = '$baseUrl/auth/me';
  static String userByIdEndpoint(int id) => '$baseUrl/users/$id';

  // Posts
  static const String postsEndpoint = '$baseUrl/posts';
  static String postsByUserEndpoint(int userId) =>
      '$baseUrl/posts/user/$userId';
  static String postCommentsEndpoint(int postId) =>
      '$baseUrl/posts/$postId/comments';

  // Comments
  static const String commentsEndpoint = '$baseUrl/comments';
  static const String addCommentEndpoint = '$baseUrl/comments/add';
  static String commentByIdEndpoint(int id) => '$baseUrl/comments/$id';

  // Shared preferences keys ----------------------------------------------
  static const String prefAccessToken = 'pref_access_token';
  static const String prefRefreshToken = 'pref_refresh_token';
  static const String prefIsLoggedIn = 'pref_is_logged_in';
  static const String prefUserData = 'pref_user_data';
  static const String prefIsDarkMode = 'pref_is_dark_mode';
  static const String prefNotificationsEnabled = 'pref_notifications_enabled';
}

/// ---------------------------------------------------------------------
/// App colors
/// ---------------------------------------------------------------------
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF1B4965);
  static const Color secondary = Color(0xFF5FA8D3);
  static const Color accent = Color(0xFFCAE9FF);
  static const Color error = Color(0xFFE63946);
  static const Color success = Color(0xFF2A9D8F);

  static const Color lightBackground = Color(0xFFF7F9FB);
  static const Color darkBackground = Color(0xFF121417);
  static const Color lightSurface = Colors.white;
  static const Color darkSurface = Color(0xFF1E2126);
}

/// ---------------------------------------------------------------------
/// Font family names (registered in pubspec.yaml)
/// ---------------------------------------------------------------------
class AppFonts {
  AppFonts._();

  static const String klavika = 'Klavika';
  static const String frutiger = 'Frutiger';
}
