import 'dart:convert';
import 'dart:io';

import 'package:bloc_login/login/login_page.dart';
import 'package:bloc_login/model/api_model.dart';
import 'package:bloc_login/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'package:bloc_login/bloc/authentication_bloc.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  void onEvent(Bloc bloc, Object event) {
    super.onEvent(bloc, event);
    print(event);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    print (transition);
  }

  @override
  void onError(Bloc bloc, Object error, StackTrace stacktrace) {
    super.onError(bloc, error, stacktrace);
  }
}

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final userRepository = UserRepository();

  runApp(
      BlocProvider<AuthenticationBloc>(
        create: (context) {
          return AuthenticationBloc(
              userRepository: userRepository
          )..add(AppStarted());
        },
        child: SignUp(userRepository: userRepository),
      )
  );
}
class SignUp extends StatefulWidget {
  final UserRepository userRepository;

  SignUp({Key key, @required this.userRepository}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState(userRepository: userRepository,);

}

class _SignUpState extends State<SignUp> {
  UserRepository userRepository;
  final textController_name=TextEditingController();
  final textController_email=TextEditingController();
  final textController_password=TextEditingController();

  final focusNode= FocusNode();
  final scafoldKey= GlobalKey<ScaffoldState>();

  final scaffoldKey= GlobalKey<ScaffoldState>();
  final formKey=GlobalKey<FormState>();

  String _email;
  String _password;
  String _name;
  _SignUpState({Key key, @required this.userRepository})
      : assert(userRepository != null);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // textController.addListener(printvalues);

  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;




    return Scaffold(
      key: scaffoldKey,
      appBar:AppBar(title: Text("SIGNUP FORM"),) ,
      body: Padding(padding: EdgeInsets.all(20.0),
        child: Form(key:formKey,
        child: Column(
          children: <Widget>[
        TextFormField(decoration: InputDecoration(labelText: "UserName"),
          validator: (val)=> val.isEmpty?'Please enter username':null,
          onSaved: (val)=>_name=val,
            controller: textController_name),
            TextFormField(decoration: InputDecoration(labelText: "Email"),
            validator: (val)=> !val.contains('@')?'Invalid Email':null,
              onSaved: (val)=>_email=val, controller: textController_email),
            TextFormField(decoration: InputDecoration(labelText: "Password"),
              validator: (val)=>val.length<6?'Password too short':null,onSaved: (val)=>val=_password,
              obscureText: true, controller: textController_password),
            Padding(padding: EdgeInsets.all(20.0),),
            Container(
             // User for customizing anything like border etc on a widget

              width: _screenSize.width * 0.8,
               height: _screenSize.height * 0.14,

              child: Padding(

                padding: EdgeInsets.only(top: 30.0),
                child: RaisedButton(
                  color: Colors.lightBlueAccent,
                  onPressed:() async {
                    await _submit();
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24.0,color: Colors.white
                    ),
                  ),
                  shape: StadiumBorder(

                    side: BorderSide(
                      color: Colors.transparent,
                      width: 2,
                    ),
                  ),

                ),

              ),
            ),
            Padding(padding: EdgeInsets.all(20.0),),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage(userRepository: userRepository,)),
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 80.0),
              child: RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(text: 'Already have an account ? ', style: TextStyle(color: Colors.lightBlueAccent,fontSize: 17)),
                    TextSpan(text: '   Login Here', style: TextStyle(color: Colors.redAccent,fontSize: 22)),
                  ],
                ),
              ),
            ),
          )
          ],
        ),),
      ),
    );
  }



  Future<Token> _submit() async {

    showLoaderDialog(context);
    
    UserSignup userLogin = UserSignup(
        name:  textController_name.text,
        email: textController_email.text,
        password: textController_password.text,
    );
    // button
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      final http.Response response = await http.post(
        "https://sumit-task-manager-nodejs.herokuapp.com/users",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(userLogin.toDatabaseJson()),
      );
      if (response.statusCode == HttpStatus.CREATED) {
        Navigator.pop(context);
        Token token= Token.fromJson(json.decode(response.body));

        final snakbar=SnackBar(content: Text("Successfully Logged in User: " + token.name),);
        scaffoldKey.currentState.showSnackBar(snakbar);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage(userRepository: userRepository,)));

      


      }else{

        Navigator.pop(context);

        final snakbar=SnackBar(content: Text("Some Error Occured, Please Try Again"),);
        scaffoldKey.currentState.showSnackBar(snakbar);

      }

    }


  }

    void performlogin() {
      final snakbar=SnackBar(content: Text("Email: $_email, Password: $_password"),);
      scaffoldKey.currentState.showSnackBar(snakbar);
    }

  showLoaderDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}


