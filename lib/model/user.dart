class User {
  String id;
  String name;
  String email;
  String mobile;
  String joinDate;

  User({
    this.id,
    this.name,
    this.email,
    this.joinDate,
  });

  factory User.fromMap(Map user) {
    return User(
      id: user['id'].toString(),
      name: user['name'],
      email: user['email'],
      joinDate: user['created_at'],
    );
  }
}
