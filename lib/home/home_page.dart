import 'dart:io';

import 'package:bloc_login/home_pages/drawer_menu.dart';
import 'package:bloc_login/newtask/create_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_login/bloc/authentication_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: new FloatingActionButton( backgroundColor: Theme.of(context).accentColor,
          child: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateTask()),
              );

    }

        ),

      appBar: AppBar(
        title: Text(' Home '),
      ),
      drawer: DrawerMenu(),
      body: Container(
        child: Column(



          children: <Widget>[
            Padding(padding: EdgeInsets.only(left: 30.0),
            child: Text(
              'Your Tasks',
              style: TextStyle(
                fontSize: 20.0,
                color: Colors.blueAccent
              ),
            ),),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),


              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 1.0,


                child:  new FutureBuilder(

                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var mydata = snapshot.data;
                      return new ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (context, i) =>
                            Column(
                              children: <Widget>[
                                Divider(height: 15.0,color: Colors.lightBlueAccent,),
                                new ListTile(
                                  title: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                           Text(mydata[i]['description']),
                                      new IconButton(
                                        icon: new Icon(
                                          Icons.restore_from_trash_outlined,
                                          color: Colors.lightBlueAccent,
                                          size: 24.0,
                                          semanticLabel: 'Text',
                                        ),
                                        onPressed: () {
                                          /* Your code for delete button click */

                                         showAlertDialog(context);

                                        },
                                      )
                                      ],
                                  ),
                                    subtitle: Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: Text(mydata[i]['_id'],
                                        style: TextStyle(color: Colors.grey,fontSize: 15.0),),
                                    )
                                  // subtitle: Text(mydata[i]['body']),
                                ),
                              ],
                            ),
                        itemCount: mydata.length,
                      );
                    } else {
                      return Center(
                        child: new CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
            ),
            RaisedButton(
              color: Colors.lightBlueAccent,
              child: Text(
                'Logout',
                style: TextStyle(
                    fontSize: 24,color: Colors.white
                ),
              ),
              onPressed: () {
                BlocProvider.of<AuthenticationBloc>(context)
                    .add(LoggedOut());
              },
              shape: StadiumBorder(
                side: BorderSide(
                  color: Colors.transparent,
                  width: 2,
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Future getData() async {

    var token = await getaccessToken();
    
    
    final http.Response response = await http.get(
      "https://sumit-task-manager-nodejs.herokuapp.com/tasks",
      headers: <String, String>{
        'Authorization': 'Bearer '+ token,
      },

    );
    if (response.statusCode == 201) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
  }

  Future<String> getaccessToken() async  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return String
    String stringValue = prefs.getString('access_token');
    return stringValue;

  }

  void showAlertDialog(BuildContext context) {

    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {


      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Would you like to continue learning how to use Flutter alerts?"),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancel"),
          onPressed:  () =>  Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Continue"),
          onPressed:  () {},
        ),
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
