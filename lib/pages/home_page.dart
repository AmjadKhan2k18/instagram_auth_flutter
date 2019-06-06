import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_auth/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  final BaseAuth auth;

  final VoidCallback onSignedOut;

  const Home({Key key, this.onSignedOut, this.auth}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String id;

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      id = prefs.getString('currentId');
    });
  }

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
      body: id == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('userProfile')
                  .document(id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return new Text("Loading");
                }
                var userDocument = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(top: 50),
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            new NetworkImage(userDocument['photoURL']),
                        radius: 50.0,
                      ),
                      Text(userDocument['displayName']),
                      Text(userDocument['email']),
                    ],
                  ),
                );
              }),
    );
  }
}
