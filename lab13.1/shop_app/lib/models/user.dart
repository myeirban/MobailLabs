class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String name;
  final String phone;
  final String avatar; //sanamsargui oorchloltoos sergiilj bn.

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.name,
    required this.phone,
    this.avatar = '',
  });

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

  bool checkPassword(String password) {
    return this.password == password;
  }

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
