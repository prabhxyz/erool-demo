class User {
  final String id;
  final String username;
  final String email;
  final List<String> topics;
  final List<String> bookmarks;
  final int streak;
  final int points;
  final List<String> badges;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.topics,
    required this.bookmarks,
    required this.streak,
    required this.points,
    required this.badges,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      topics: List<String>.from(json['topics'] ?? []),
      bookmarks: List<String>.from(json['bookmarks'] ?? []),
      streak: json['streak'] ?? 0,
      points: json['points'] ?? 0,
      badges: List<String>.from(json['badges'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'topics': topics,
      'bookmarks': bookmarks,
      'streak': streak,
      'points': points,
      'badges': badges,
    };
  }
} 