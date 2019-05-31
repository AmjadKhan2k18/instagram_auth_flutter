import 'package:flutter/material.dart';

import 'auth.dart';

class Home extends StatefulWidget {
  final BaseAuth auth;

  final VoidCallback onSignedOut;

  const Home({Key key, this.onSignedOut, this.auth}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            onPressed: widget.onSignedOut,
            icon: Icon(Icons.power_settings_new),
          )
        ],
        title: Text(""),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Text("Signed in"),
      ),
    );
  }
}
