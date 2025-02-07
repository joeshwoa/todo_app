class User {
  final String id;
  final String username;
  final String email;
  final String avatarUrl;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}
