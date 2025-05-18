class User {
  final String id;
  final String email;
  final String username;
  final String fullName;
  final String? avatar;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.fullName,
    this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      email: json['email'],
      username: json['username'],
      fullName: json['name']['firstname'] + ' ' + json['name']['lastname'],
      avatar: json['avatar'],
    );
  }
}