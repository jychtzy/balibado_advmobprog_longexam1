class Reactions {
  final int likes;
  final int dislikes;

  Reactions({this.likes = 0, this.dislikes = 0});

  factory Reactions.fromJson(Map<String, dynamic> json) {
    return Reactions(
      likes: json['likes'] ?? 0,
      dislikes: json['dislikes'] ?? 0,
    );
  }
}

/// Model representing a dummyjson post.
class PostModel {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final Reactions reactions;
  final int views;
  final int userId;

  PostModel({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      reactions: json['reactions'] != null
          ? Reactions.fromJson(json['reactions'])
          : Reactions(),
      views: json['views'] ?? 0,
      userId: json['userId'] ?? 0,
    );
  }
}
