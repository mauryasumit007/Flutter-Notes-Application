import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Welcome to'
            ' Flutter Notes App!',style: TextStyle(
            color: Colors.lightBlueAccent,
            fontSize: 22.0)),
      ),
    );
  }
}
