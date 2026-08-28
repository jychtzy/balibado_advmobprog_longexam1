class CommentUser {
  final int id;
  final String username;
  final String fullName;

  CommentUser({required this.id, required this.username, required this.fullName});

  factory CommentUser.fromJson(Map<String, dynamic> json) {
    return CommentUser(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      fullName: json['fullName'] ?? '',
    );
  }
}

/// Model representing a dummyjson comment.
/// Adds a local-only [isLikedByMe] flag so the UI can toggle the like
/// button per-session (the dummyjson API does not persist changes).
class CommentModel {
  final int id;
  final String body;
  final int postId;
  int likes;
  final CommentUser user;
  bool isLikedByMe;

  CommentModel({
    required this.id,
    required this.body,
    required this.postId,
    required this.likes,
    required this.user,
    this.isLikedByMe = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'] ?? 0,
      body: json['body'] ?? '',
      postId: json['postId'] ?? 0,
      likes: json['likes'] ?? 0,
      user: json['user'] != null
          ? CommentUser.fromJson(json['user'])
          : CommentUser(id: 0, username: 'unknown', fullName: 'Unknown'),
    );
  }

  /// Toggles the local like state and adjusts the like counter.
  void toggleLike() {
    if (isLikedByMe) {
      likes = (likes - 1).clamp(0, 1 << 31);
      isLikedByMe = false;
    } else {
      likes += 1;
      isLikedByMe = true;
    }
  }
}
