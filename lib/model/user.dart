import 'dart:convert';

class User {
  int id;
  final String username;
  final String password;

  User({this.id, this.username, this.password});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password == null ? "" : password,
        'id': id == null ? -1 : id,
      };
}

void main() {
  var user = User(username: "周");
  var data = jsonEncode(user);
  print(data);
}
