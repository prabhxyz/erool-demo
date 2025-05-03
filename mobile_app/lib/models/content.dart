class Content {
  final String id;
  final String title;
  final String content;
  final String topic;
  final String difficulty;
  final String authorId;
  final String authorUsername;
  final List<String> likes;
  final List<Comment> comments;
  final List<String> tags;
  final int readingTime;
  final DateTime createdAt;

  Content({
    required this.id,
    required this.title,
    required this.content,
    required this.topic,
    required this.difficulty,
    required this.authorId,
    required this.authorUsername,
    required this.likes,
    required this.comments,
    required this.tags,
    required this.readingTime,
    required this.createdAt,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      topic: json['topic'],
      difficulty: json['difficulty'] ?? 'Beginner',
      authorId: json['author']['_id'],
      authorUsername: json['author']['username'],
      likes: List<String>.from(json['likes'] ?? []),
      comments: (json['comments'] as List?)
          ?.map((comment) => Comment.fromJson(comment))
          .toList() ?? [],
      tags: List<String>.from(json['tags'] ?? []),
      readingTime: json['readingTime'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}

class Comment {
  final String id;
  final String userId;
  final String text;
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      userId: json['user'],
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
} 