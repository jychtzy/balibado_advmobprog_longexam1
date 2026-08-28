import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/post.dart';

/// Wraps https://dummyjson.com/docs/posts
class PostService {
  /// Get all posts (paginated). Used by the newsfeed screen.
  Future<List<PostModel>> getAllPosts({int limit = 30, int skip = 0}) async {
    final uri = Uri.parse(
      '${AppConstants.postsEndpoint}?limit=$limit&skip=$skip',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final posts = (data['posts'] as List<dynamic>)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return posts;
    }
    throw Exception('Failed to load posts');
  }

  /// Get all posts belonging to [userId].
  /// GET https://dummyjson.com/posts/user/{userId}
  Future<List<PostModel>> getPostsByUser(int userId) async {
    final response =
        await http.get(Uri.parse(AppConstants.postsByUserEndpoint(userId)));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final posts = (data['posts'] as List<dynamic>)
          .map((e) => PostModel.fromJson(e))
          .toList();
      return posts;
    }
    throw Exception('Failed to load posts for user $userId');
  }

  Future<PostModel> getPostById(int id) async {
    final response =
        await http.get(Uri.parse('${AppConstants.postsEndpoint}/$id'));

    if (response.statusCode == 200) {
      return PostModel.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load post $id');
  }
}
