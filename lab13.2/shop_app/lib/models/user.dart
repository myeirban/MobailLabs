/// Model class representing a user in the application
class User {
  /// Unique identifier for the user
  final int id;
  
  /// User's login username
  final String username;
  
  /// User's email address
  final String email;
  
  /// User's password (Note: In a real app, this should be hashed)
  final String password;
  
  /// User's full name
  final String name;
  
  /// User's phone number
  final String phone;
  
  /// URL to user's avatar image
  final String avatar; //sanamsargui oorchloltoos sergiilj bn.

  /// Creates a new User instance
  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    this.avatar = '',
  });

  /// Creates a User instance from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      name: '${json['name']['firstname']} ${json['name']['lastname']}',
      phone: json['phone'] as String,
      avatar: json['avatar'] as String? ?? '',
    );
  }

  /// Converts the User instance to JSON data
  /// Note: In a real app, we should not include the password in the JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'name': name,
      'phone': phone,
      'avatar': avatar,
    };
  }

  /// Checks if the provided password matches the user's password
  bool checkPassword(String password) {
    return this.password == password;
  }

  /// Creates a copy of this user with updated fields
  User copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? name,
    String? phone,
    String? avatar,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      avatar: avatar ?? this.avatar,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, username: $username, name: $name)';
  }
}
