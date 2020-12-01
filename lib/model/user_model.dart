class User {
  String id;
  String email;
  String token;

  User(
      {this.id,
        this.email,
        this.token});

  factory User.fromDatabaseJson(Map<String, dynamic> data) => User(
    id: data['_id'],
    email: data['email'],
    token: data['token'],
  );

  Map<String, dynamic> toDatabaseJson() => {
    "id": 0,
    "email": this.email,
    "token": this.token
  };
}