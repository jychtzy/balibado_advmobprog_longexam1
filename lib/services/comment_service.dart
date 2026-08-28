import 'dart:convert';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/comment.dart';

/// Wraps https://dummyjson.com/docs/comments
class CommentService {
  /// Get all comments for [postId].
  /// GET https://dummyjson.com/comments/post/{postId}
  Future<List<CommentModel>> getCommentsByPost(int postId) async {
    final response = await http
        .get(Uri.parse('${AppConstants.commentsEndpoint}/post/$postId'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final comments = (data['comments'] as List<dynamic>)
          .map((e) => CommentModel.fromJson(e))
          .toList();
      return comments;
    }
    throw Exception('Failed to load comments for post $postId');
  }

  /// Adds a new comment. Per the dummyjson docs this is simulated
  /// server-side (it will NOT actually persist), but it returns a
  /// realistic new comment object that we then keep in local state.
  /// POST https://dummyjson.com/comments/add
  Future<CommentModel> addComment({
    required String body,
    required int postId,
    required int userId,
  }) async {
    final response = await http.post(
      Uri.parse(AppConstants.addCommentEndpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'body': body,
        'postId': postId,
        'userId': userId,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      // dummyjson's /comments/add response omits `likes`; default to 0.
      data['likes'] = data['likes'] ?? 0;
      return CommentModel.fromJson(data);
    }
    throw Exception('Failed to add comment');
  }
}
