import 'package:flutter/material.dart';
import 'package:social_auth/services/auth.dart';
import 'package:social_auth/services/root.dart';



void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey,
        accentColor: Color(0xff64C28E),
      ),
      home: new RootPage(auth: Auth()),
    ));

