import 'dart:convert';
import 'dart:io';

import 'package:bloc_login/login/login_page.dart';
import 'package:bloc_login/model/api_model.dart';
import 'package:bloc_login/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class CreateTask extends StatefulWidget {
// Declare this variable

  CreateTask();

  @override
  _CreateTaskState createState() => _CreateTaskState();

}

class _CreateTaskState extends State<CreateTask> {
  UserRepository userRepository;
  final textController_description=TextEditingController();

// Declare this variable
  int selectedRadioTile;
  final focusNode= FocusNode();
  final scafoldKey= GlobalKey<ScaffoldState>();

  final scaffoldKey= GlobalKey<ScaffoldState>();
  final formKey=GlobalKey<FormState>();


  String _description;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // textController.addListener(printvalues);
    selectedRadioTile = 0;
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;




    return Scaffold(
      key: scaffoldKey,
      appBar:AppBar(title: Text("Create New Task"),) ,
      body: Padding(padding: EdgeInsets.all(20.0),
        child: Form(key:formKey,
          child: Column(
            children: <Widget>[
              TextFormField(decoration: InputDecoration(labelText: "Enter Task description"),
                  validator: (val)=> val.isEmpty?'Please Enter Task Description!!!':null,
                  onSaved: (val)=>_description=val,
                  controller: textController_description),


              Padding(padding: EdgeInsets.all(10.0),),
              Row(

                children: [
                  Text("Is Task Completed??",style: TextStyle(color: Colors.lightBlueAccent),textAlign: TextAlign.start,),
                ],
              ),
              Padding(padding: EdgeInsets.only(top:20.0),),

              RadioListTile(
                value: 1,
                groupValue: selectedRadioTile,
                title: Text("Yes"),
                subtitle: Text("Task completed"),
                onChanged: (val) {
                  print("Radio Tile pressed $val");
                  setSelectedRadioTile(val);
                },
                activeColor: Colors.red,


              ),
              RadioListTile(
                value: 2,
                groupValue: selectedRadioTile,
                title: Text("No"),
                subtitle: Text("Task not completed"),
                onChanged: (val) {
                  print("Radio Tile pressed $val");
                  setSelectedRadioTile(val);
                },
                activeColor: Colors.red,


              ),
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

    final form = formKey.currentState;
    if(form.validate()){
      await _submit();
    }



                    },
                    child: Text(
                      'Create Task',
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

            ],
          ),),
      ),
    );
  }



  Future<Token> _submit() async {
    var token = await getaccessToken();



    CreateTaskModel cmodel=null;
    showLoaderDialog(context);
    if(selectedRadioTile==1){
      cmodel = CreateTaskModel(
          description:  textController_description.text,
          val: true
      );

    }else{

      cmodel = CreateTaskModel(
          description:  textController_description.text,
          val: false
      );
    }


    // button
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      final http.Response response = await http.post(
        "https://sumit-task-manager-nodejs.herokuapp.com/tasks/",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer '+ token
        },
        body: jsonEncode(cmodel.toDatabaseJson()),
      );
      if (response.statusCode == HttpStatus.CREATED) {
        Navigator.pop(context);

        final snakbar=SnackBar(content: Text("Task Created Successfully!"),);
        scaffoldKey.currentState.showSnackBar(snakbar);
        // Navigator.of(context).popUntil((route) => route.isFirst);
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => LoginPage(userRepository: userRepository,)));

      }else{

        Navigator.pop(context);

        final snakbar=SnackBar(content: Text("Some Error Occured, Please Try Again"),);
        scaffoldKey.currentState.showSnackBar(snakbar);

      }

    }


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

  Future<String> getaccessToken() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('access_token');
    return stringValue;

  }
}


