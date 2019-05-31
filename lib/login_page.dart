import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginPage extends StatefulWidget {
  final VoidCallback onSignedIn;
  LoginPage({this.onSignedIn});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Size size;

  // FirebaseAuth _auth = FirebaseAuth.instance;

  // GoogleSignIn _googleSignIn;
  @override
  void initState() {
    super.initState();
    // _googleSignIn = GoogleSignIn(
    //     scopes: [
    //       'email',
    //       'https://www.googleapis.com/auth/contacts.readonly',
    //     ],
    //   );
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult =
        await facebookLogin.logInWithReadPermissions(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");

        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");

        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        var myToken = facebookLoginResult.accessToken;
        AuthCredential credential =
            FacebookAuthProvider.getCredential(accessToken: myToken.token);
        FirebaseAuth.instance.signInWithCredential(credential);
        widget.onSignedIn();
        break;
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> _handleGoogleSignIn() async {
    try {
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      FirebaseUser user =
          await FirebaseAuth.instance.signInWithCredential(credential);
      debugPrint("${user.displayName}");

      widget.onSignedIn();
      // AuthCredential credential = FacebookAuthProvider.getCredential(accessToken: myToken.token);
      //     FirebaseAuth.instance.linkWithCredential(credential);

    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Sign in"),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Container(
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Expanded(child: Container()),
          Expanded(child: _buildSignInWithFbBtn()),
          Expanded(child: Container()),
          Expanded(child: _buildSignInWIthGoogleBtn()),
          Expanded(child: Container()),
          Expanded(child: _buildSignInWIthInstagramBtn()),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  Widget _buildSignInWithFbBtn() {
    return Container(
      margin: EdgeInsets.only(right: 8, left: 8, bottom: 20),
      height: 40,
      width: size.width,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: Color(0xff3B5998),
        onPressed: () {
          initiateFacebookLogin();
        },
        child: Text(
          "Facebook",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSignInWIthInstagramBtn() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 8, right: 8),
      height: 40,
      width: size.width,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: Color(0xfffb3958),
        onPressed: _handleSignIn,
        child: Text(
          "Instagram",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildSignInWIthGoogleBtn() {
    return Container(
      margin: EdgeInsets.only(bottom: 20, left: 8, right: 8),
      height: 40,
      width: size.width,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        color: Color(0xffDD4B39),
        onPressed: _handleGoogleSignIn,
        child: Text(
          "Google",
          style: TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
