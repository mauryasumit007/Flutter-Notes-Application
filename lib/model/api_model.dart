class UserLogin {
  String email;
  String password;


  UserLogin({this.email, this.password});

  Map <String, dynamic> toDatabaseJson() => {
    "email": this.email,
    "password": this.password
  };
}

class UserSignup {
  String email;
  String password;
  String name;

  UserSignup({this.name,this.email, this.password});

  Map <String, dynamic> toDatabaseJson() => {
    "name": this.name,
    "email": this.email,
    "password": this.password
  };
}

class Token{
  String token, id,name;

  Token({this.token,this.id,this.name});

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      token: json['token'],
      id: json['user']['_id'],
        name: json['user']['name']
    );
  }
}

class CreateTaskModel {
  String description;
  bool val;

  CreateTaskModel({this.description,this.val});


  Map <String, dynamic> toDatabaseJson() => {
    "description": this.description,
    "completed": this.val
  };
}


class UpdateProfileModel {
  String age,emailid;


  UpdateProfileModel({this.age,this.emailid});


  Map <String, dynamic> toDatabaseJson() => {
    "age": this.age,
    "email": this.emailid
  };
}




