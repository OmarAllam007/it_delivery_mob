import 'dart:convert';

class User {
  String id;
  String name;
  String email;
  String mobile;
  String joinDate;
  String token;
  List locations;

  User(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.joinDate,
      this.token,
      this.locations});

  factory User.fromMap(Map user) {
    return User(
      id: user['id'].toString(),
      name: user['name'],
      email: user['email'],
      mobile: user['mobile'],
      joinDate: user['created_at'],
      locations: user['locations'],
    );
  }

  Map toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "mobile": mobile,
      "created_at": joinDate,
      "locations": locations
    };
  }
}
