import 'package:flutter/material.dart';
import 'package:social_auth/auth.dart';
import 'package:social_auth/home_page.dart';

import 'login_page.dart';


class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage({this.auth});

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus {
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notSignedIn;

  var userId;
  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userId) {
      setState(() {
         authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
         this.userId = userId;
      });
    });
  }

  void _singedIn(){
    setState(() {
          authStatus = AuthStatus.signedIn;
        });
  }
 
  void _signedOut(){
    widget.auth.signOut();
    setState(() {
          authStatus = AuthStatus.notSignedIn;
        });
  }

  @override
  Widget build(BuildContext context) {
    
    switch (authStatus) {
      case AuthStatus.notSignedIn:
        return LoginPage(onSignedIn: _singedIn,);
      case AuthStatus.signedIn:
        return Home(auth: widget.auth,onSignedOut: _signedOut);
    }
    return null;
  }
}