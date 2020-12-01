import 'dart:async';
import 'package:bloc_login/model/user_model.dart';
import 'package:meta/meta.dart';
import 'package:bloc_login/model/api_model.dart';
import 'package:bloc_login/api_connection/api_connection.dart';
import 'package:bloc_login/dao/user_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserRepository {
  String emailtocheck="";
  final userDao = UserDao();

  Future<User> authenticate ({
    @required String email,
    @required String password,
  }) async {
    emailtocheck= email;
    UserLogin userLogin = UserLogin(
        email: email,
        password: password
    );
    Token token = await getToken(userLogin);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('access_token', token.token);

    User user = User(
      id: token.id,
      email: email,
      token: token.token,
    );
    return user;
  }

  Future<void> persistToken ({
    @required User user
  }) async {
    // write token with the user to the database

   if(await userDao.checkUser(emailtocheck)!=true){
     await userDao.createUser(user);

   }else{


   }

  }

  Future <void> delteToken({
    @required int id
  }) async {
    await userDao.deleteUser(id);
  }

  Future <bool> hasToken() async {
    bool result = await userDao.checkUser(emailtocheck);
    return result;
  }



}