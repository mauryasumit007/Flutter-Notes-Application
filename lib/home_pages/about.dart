
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:bloc_login/home/home_page.dart';
import 'package:bloc_login/model/api_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:flutter_lorem.dart';
import 'drawer_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class About extends StatefulWidget {
 // String text = lorem(paragraphs: 3, words: 50);



  @override
  _AboutState  createState() => _AboutState();
}

class _AboutState extends State<About> {
  final scaffoldKey= GlobalKey<ScaffoldState>();
  final formKey=GlobalKey<FormState>();
  TextEditingController textController_age = TextEditingController();
  TextEditingController textController_email = TextEditingController();
  TextEditingController textController_id = TextEditingController() ;
  File _image;
  var token="";
  Future<bool> xv;
  Future img;
  bool isDataAvailable = false;
  Map<String, dynamic> data = Map();
  String _age,_emailId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    xv= getProfileData(token);
  }

  Future<bool> getProfileData(String token) async {

    token = await getaccessToken();
    // data = await callprofileDataAPI(token);
    final http.Response response = await http.get(
      "https://sumit-task-manager-nodejs.herokuapp.com/users/me",
      headers: <String, String>{
        'Authorization': 'Bearer '+ token,
      },

    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      data = jsonDecode(response.body);
    } else {

      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }

    setState(() {
      isDataAvailable = true;
      textController_age.text = data["age"].toString(); //sorry
      textController_email.text = data["email"].toString();//not neccessary you oakre already getting string form json
      textController_id.text = data["_id"].toString();
    });

    return isDataAvailable;
  }

  Future _updateProfileAPI() async {
    var token = await getaccessToken();

// no issues in this its working
    //dont you need _id?.. no id will be disabled to edit later ok

    UpdateProfileModel cmodel=null;
    showLoaderDialog(this.context);

    cmodel = UpdateProfileModel(
        age:  textController_age.text,
        emailid: textController_email.text
    );



    // button
    final form = formKey.currentState;
    if(form.validate()){
      form.save();
      http.Response response;

      response = await http.patch(
        "https://sumit-task-manager-nodejs.herokuapp.com/users/me",

        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer '+ token
        },
        body: jsonEncode(cmodel.toDatabaseJson()),
      );



      if (response.statusCode == HttpStatus.OK) {
        Navigator.pop(this.context);

        setState(() {
          final snakbar=SnackBar(content: Text("Profile Updated Successfully!"),);
          scaffoldKey.currentState.showSnackBar(snakbar);
        });




      }else{

        Navigator.pop(this.context);

        final snakbar=SnackBar(content: Text("Some Error Occured, Please Try Again"),);
        scaffoldKey.currentState.showSnackBar(snakbar);

      }

    }


  }




  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
var imgtoLoad = new NetworkImage(
    "https://sumit-task-manager-nodejs.herokuapp.com/users/5fb583d537a2a00017e82704/avatar");
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(
        title: Text('About'),

      ),
      drawer: DrawerMenu(),
      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(20.0),

          child:
          new FutureBuilder(

              future: xv,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // var mydata = snapshot.data;  // this i will change as per your template
                  // textController_email.text=mydata["email"] as String;
                  // textController_age.text=(mydata["age"] as int).toString();   // what about it? its resetting whenever i click edittext so new value not reflect
                  if(snapshot.data) {
                    return Form(key: formKey,
                      child: Column(
                        children: <Widget>[

                          new Center(
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[

                                  Padding(
                                    padding: const EdgeInsets.only(left: 25.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .center,
                                      mainAxisAlignment: MainAxisAlignment
                                          .center,
                                      children: [
                                        _image != null
                                            ? ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              50),
                                          child: Image.file(
                                            _image,
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        )
                                            : ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              50),
                                          child: Image.network(
                                            'https://sumit-task-manager-nodejs.herokuapp.com/users/'+data["_id"]+'/avatar',
                                            width: 150,
                                            height: 150,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),

                                        Padding(

                                          padding: const EdgeInsets.only(
                                              top: 100.0),
                                          child: new IconButton(
                                            icon: new Icon(
                                              Icons.edit_outlined,
                                              color: Colors.black,
                                              size: 24.0,
                                              semanticLabel: 'Text',
                                            ),
                                            onPressed: () {
                                              // Image pick options


                                              _showPicker(context,
                                                  onGallery: () async { // This will be called when user taps 'YES'
                                                    File image = await ImagePicker
                                                        .pickImage(
                                                        source: ImageSource
                                                            .gallery,
                                                        imageQuality: 50
                                                    );

                                                    String result = await _uploadAvatar(
                                                        textController_id.text
                                                            .toString(), token,
                                                        context, image);

                                                    if (result == 'success') {
                                                      final snakbar = SnackBar(
                                                        content: Text(
                                                            "Image Uploaded Successfully"),);
                                                      scaffoldKey.currentState
                                                          .showSnackBar(
                                                          snakbar);
                                                      setState(() {
                                                        _image = image;
                                                      });
                                                    } else {
                                                      final snakbar = SnackBar(
                                                        content: Text(
                                                            "Some Error Occured, Please Try Again"),);
                                                      scaffoldKey.currentState
                                                          .showSnackBar(
                                                          snakbar);
                                                    }
                                                  },
                                                  onCamera: () async { // This will be called when user taps 'CANCEL'

                                                    File image = await ImagePicker
                                                        .pickImage(
                                                        source: ImageSource
                                                            .camera,
                                                        imageQuality: 50
                                                    );
                                                    String result = await _uploadAvatar(
                                                        textController_id.text
                                                            .toString(), token,
                                                        context, image);

                                                    if (result == 'success') {
                                                      final snakbar = SnackBar(
                                                        content: Text(
                                                            "Image Uploaded Successfully"),);
                                                      scaffoldKey.currentState
                                                          .showSnackBar(
                                                          snakbar);
                                                      setState(() {
                                                        _image = image;
                                                      });
                                                    } else {
                                                      final snakbar = SnackBar(
                                                        content: Text(
                                                            "Some Error Occured, Please Try Again"),);
                                                      scaffoldKey.currentState
                                                          .showSnackBar(
                                                          snakbar);
                                                    }

                                                    setState(() {
                                                      _image = image;
                                                    });
                                                  });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: new Text(data["name"] as String,
                                        textScaleFactor: 1.5),
                                  )
                                ],
                              )),

                          TextFormField(decoration: InputDecoration(
                              labelText: "User ID"),
                              enabled:false,
                              validator: (val) =>
                              val.isEmpty
                                  ? 'Please Enter id'
                                  : null,
                              style: TextStyle(fontSize: 18.0),
                              controller: textController_id,

                          ),

                          Padding(padding: EdgeInsets.only(top: 10.0),),

                          TextFormField(decoration: InputDecoration(
                              labelText: "Age"),
                              validator: (val) =>
                              val.isEmpty
                                  ? 'Please Enter age!!!'
                                  : null,
                              onSaved: (val) => _age = val,
                              style: TextStyle(fontSize: 18.0),
                              controller: textController_age),

                          Padding(padding: EdgeInsets.only(top: 10.0),),

                          TextFormField(decoration: InputDecoration(
                              labelText: "Email ID"),
                              validator: (val) =>
                              val.isEmpty
                                  ? 'Please Enter Email ID!!!'
                                  : null,
                              onSaved: (val) => _emailId = val,
                              style: TextStyle(fontSize: 18.0),
                              controller: textController_email),

                          Container(
                            // User for customizing anything like border etc on a widget

                            width: _screenSize.width * 0.8,
                            height: _screenSize.height * 0.14,

                            child: Padding(

                              padding: EdgeInsets.only(top: 30.0),
                              child: RaisedButton(
                                color: Colors.lightBlueAccent,
                                onPressed: () async {
                                  final form = formKey.currentState;
                                  if (form.validate()) {
                                    await _updateProfileAPI();
                                  }
                                },
                                child:
                                Text(
                                  'Update Profile',
                                  style: TextStyle(
                                      fontSize: 18.0, color: Colors.white
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
                          Padding(padding: EdgeInsets.all(10.0),),

                        ],
                      ),);
                  }else
                    return Center(child: Text("Unable to fetch Profile data"));
                } else {
                  return Center(
                    child: new CircularProgressIndicator(),
                  );
                }
              }),

        ),
      ),
    );
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

  Future callprofileDataAPI(String token) async {

    final http.Response response = await http.get(
      "https://sumit-task-manager-nodejs.herokuapp.com/users/me",
      headers: <String, String>{
        'Authorization': 'Bearer '+ token,
      },

    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }


  }

  Future<String> _uploadAvatar(String string, String token, BuildContext context, File imageFile) async {
    token = await getaccessToken();
    String res="";
    showLoaderDialog(context);
    Map<String, String> header = { 'Authorization': 'Bearer '+ token};

    // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://sumit-task-manager-nodejs.herokuapp.com/users/me/avatar");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('avatar', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.headers.addAll(header);
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });

    if (response.statusCode == 200) {
      Navigator.pop(context);
      res = "success";

      return res;
    } else {
      new CircularProgressIndicator();

      res ="failure";
      return res;
    }



  }



}

void _showPicker(BuildContext context,{Function onGallery, Function onCamera}) async{
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {

                      Navigator.of(context).pop();
                      if (null != onGallery) onGallery();
                    }),
                new ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    if (null != onCamera) onCamera();
                  },
                ),
              ],
            ),
          ),
        );
      }
  );
}

