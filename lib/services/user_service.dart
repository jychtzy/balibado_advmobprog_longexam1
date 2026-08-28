import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/user.dart';

/// Wraps the read-only parts of https://dummyjson.com/docs/users
/// that are used outside of authentication (e.g. viewing another
/// user's profile).
class UserService {
  Future<UserModel> getUserById(int id) async {
    final response = await http.get(Uri.parse(AppConstants.userByIdEndpoint(id)));

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load user $id');
  }
}
