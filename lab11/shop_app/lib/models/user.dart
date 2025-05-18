class User {
  //Hereglegchiin medeelliig hadgalah zorilgotoi
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
  //JSON -> User obiekt
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'], //json dotor name ni ooroo obiekt baidag
      name: json['name']['firstname'] + ' ' + json['name']['lastname'],
      phone: json['phone'],
      avatar:
          json['avatar'] ??
          '', //json dotor avatar utga baihgui bol null songono.
    );
  }
  //ene ni ogogdliig butsaaj hadgalj bn.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password, //shifrleh ni zugeer
      'name': name,
      'phone': phone,
      'avatar': avatar,
    };
  }
}
