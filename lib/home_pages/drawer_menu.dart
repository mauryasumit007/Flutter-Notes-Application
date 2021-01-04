import 'package:bloc_login/bloc/authentication_bloc.dart';
import 'package:bloc_login/home_pages/about.dart';
/**
 * Created by sumit maurya
 */
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const kTitle = 'Flutter Notes App';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text(
                kTitle,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.title.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
            ),
          ),
          getListTile('Home', onTap: () {
            Navigator.pushReplacementNamed(context, '/');
          }),
          getLine(),
          getListTile('My Profile', onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new About(),
              ),
            );
          }),
          getLine(),
          getListTile('Logout', onTap: () {
            BlocProvider.of<AuthenticationBloc>(context)
                .add(LoggedOut());
          }),
        ],
      ),
    );
  }

  Widget getLine() {
    return SizedBox(
      height: 0.5,
      child: Container(
        color: Colors.grey,
      ),
    );
  }

  Widget getListTile(title, {Function onTap}) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }

//  Function gotoScreen(BuildContext context, String name) {
//    if (name == 'home') {
//      Navigator.pushNamed(context, '/');
//    } else if (name == 'about') {
//      Navigator.pushNamed(context, '/about');
//    } else if (name == 'settings') {
//      Navigator.pushNamed(context, '/settings');
//    }
//  }
}