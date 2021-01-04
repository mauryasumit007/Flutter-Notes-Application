import 'dart:io';

import 'package:bloc_login/home_pages/drawer_menu.dart';
import 'package:bloc_login/newtask/create_task.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_login/bloc/authentication_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var token="";
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  Future<bool> xv; //Future returns either true or false depending on wheather your data is empty or not
  List<dynamic> data  = [];
  bool isDataAvailable = false;  //variable controlling return value in future method
  @override
  void initState() {
    super.initState();

    xv= getData(token);

  }

  Future<bool> getData(String token) async {  //Future returning the vale of the controlling bool variable and also storing incoming data in data variable

    token = await getaccessToken();


    final http.Response response = await http.get(
      "https://sumit-task-manager-nodejs.herokuapp.com/tasks",
      headers: <String, String>{
        'Authorization': 'Bearer '+ token,
      },

    );
    if (response.statusCode == 201) {
      var result = jsonDecode(response.body);
      data = jsonDecode(response.body); //This is your actuall data
      print(data);
      if(data.length > 0) //if your list is not empty then you have some to display otherwise isDataAvailable will remain false and you will show No data available
        isDataAvailable = true;


      setState(() { //makes sure that whenever getData() is called and regardless if you have new item added or not. data variable refreshes
                 // everytime this should be used to refresh any list or any widget?
        //yes if you know that your data is altered in any way and you want to reflect same changes in widget, you need to rebuild it with new data using setState
        // ok ok
      });

    } else {
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
    return isDataAvailable;
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: new FloatingActionButton( backgroundColor: Theme.of(context).accentColor,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CreateTask("newTask","",false,"")),
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
            Padding(padding: EdgeInsets.all( 20.0),
              child: Text(
                'Your Tasks',
                style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.lightBlueAccent
                ),
              ),),
            Padding(
              padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 0.0),


              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: MediaQuery.of(context).size.width * 1.0,


                child:  RefreshIndicator(
                  onRefresh: () => getData(token),
                  child: new FutureBuilder(

                    future: xv,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if(snapshot.data) {
                          return new ListView.builder(
                            shrinkWrap: false,
                            itemBuilder: (context, i) =>
                                Column(
                                  children: <Widget>[
                                    Divider(height: 6.0,
                                      color: Colors.lightBlueAccent,),
                                    new ListTile(
                                        title: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .start,
                                          children: [

                                            Container(
                                                width: 75.0,
                                                child: Text(data.elementAt(i)['description'])),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 100.0),
                                              child: new IconButton(
                                                icon: new Icon(
                                                  Icons.delete_forever,
                                                  color: Colors.redAccent,
                                                  size: 24.0,
                                                  semanticLabel: 'Text',
                                                ),
                                                onPressed: () {
                                                  /* Your code for delete button click */

                                                  Future.delayed(
                                                      Duration.zero, () =>
                                                      setState(() {
                                                        showAlertDialog(context,
                                                            onYes: () async { // This will be called when user taps 'YES'

                                                              showLoaderDialog(
                                                                  context);

                                                              String result = await _deleteTask(
                                                                  data
                                                                      .elementAt(i)['_id'],
                                                                  token,
                                                                  context);
                                                              print(result);
                                                              if (result ==
                                                                  "success") {
                                                                Navigator.pop(
                                                                    context);
                                                                setState(() {//this is correct ok
                                                                  data.removeAt(
                                                                      i);
                                                                  Scaffold.of(
                                                                      context)
                                                                      .showSnackBar(
                                                                      SnackBar(
                                                                          content: Text(
                                                                              "Task Deleted Successfully")));
                                                                });
                                                              } else {
                                                                Scaffold.of(
                                                                    context)
                                                                    .showSnackBar(
                                                                    SnackBar(
                                                                        content: Text(
                                                                            "Some Error Occured")));
                                                              }
                                                            },
                                                            onCancel: () { // This will be called when user taps 'CANCEL'
                                                              Scaffold.of(
                                                                  context)
                                                                  .showSnackBar(
                                                                  SnackBar(
                                                                      content: Text(
                                                                          "Canceled")));
                                                            });
                                                      }));
                                                },
                                              ),
                                            ),

                                            new IconButton(
                                              icon: new Icon(
                                                Icons.edit_outlined,
                                                color: Colors.black,
                                                size: 24.0,
                                                semanticLabel: 'Text',
                                              ),
                                              onPressed: () {
                                                /* Your code for delete button click */

                                                Future.delayed(
                                                    Duration.zero, () =>
                                                    setState(() {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                CreateTask(
                                                                    "updateTask",
                                                                    data
                                                                        .elementAt(
                                                                        i)['description'],
                                                                    data
                                                                        .elementAt(
                                                                        i)['completed'],
                                                                    data
                                                                        .elementAt(
                                                                        i)['_id'])),
                                                      );
                                                    }));
                                              },
                                            )
                                          ],
                                        ),
                                        subtitle: Container(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: Builder(
                                              builder: (context) {
                                                if (data.elementAt(
                                                    i)['completed'] == true) {
                                                  return Text("Task Completed",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15.0),);
                                                } else {
                                                  return Text("Task Pending",
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 15.0),);
                                                }
                                              }
                                          )
                                          ,
                                        )

                                    ),

                                  ],
                                ),
                            itemCount: data.length,
                          );
                        }else
                          return Center(child: Text("No data available at this time"));
                      } else {
                        return Center(
                          child: new CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              ),
            )


          ],
        ),
      ),
    );
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

// Future<String> showAlertDialog(BuildContext context, String mydata, String tokenA,var mydataa, int pos, GlobalKey<ScaffoldState> scaffoldkey) async {

void showAlertDialog(BuildContext context, {Function onYes, Function onCancel}) async {

  // set up the AlertDialog

  // show the dialog
  try{
    showDialog (
      context: context,
      builder: (BuildContext context) {
        return  StatefulBuilder(builder: (context,setState){
          return AlertDialog(
            title: Text("Alert"),
            content: Text("Delete Selected Task ??"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed:  () {
                  Navigator.pop(context);
                  if (null != onCancel) onCancel();
                } ,
              ),
              FlatButton(
                child: Text("Continue"),
                onPressed:  () async {
                  Navigator.pop(context);
                  if (null != onYes) onYes(); // Ensure the reference exists before calling it
                  //  var resultant=  await _deleteTask(mydata,tokenA,context);

                },
              ),
            ],
          );



        });
      },
    );
    print('ghhghghgh');
  }on Exception catch (exception) {
    print(exception);
  } catch (error) {
    print(error);
  }
}

Future<String> _deleteTask(String taskid, String token, BuildContext context) async {
  String res="";
  new CircularProgressIndicator();


  final http.Response response = await http.delete(
    "https://sumit-task-manager-nodejs.herokuapp.com/tasks/"+taskid,
    headers: <String, String>{
      'Authorization': 'Bearer '+ token,
    },

  );
  if (response.statusCode == 200) {
    // Navigator.pop(context);
    //var result = jsonDecode(response.body);
    res = "success";

    return res;
  } else {
    // Navigator.pop(context);
    print(json.decode(response
        .body).toString());
    throw Exception(json.decode(response.body));
    res ="failure";
    return res;
  }


}