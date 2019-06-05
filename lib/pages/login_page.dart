import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:social_auth/services/instagram.dart';
import 'package:social_auth/services/login_presenter.dart';
import 'package:cloud_functions/cloud_functions.dart';


GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
    'https://www.googleapis.com/auth/contacts.readonly',
  ],
);

class LoginPage extends StatefulWidget {
  final GlobalKey<ScaffoldState> skey;
  final VoidCallback onSignedIn;
  LoginPage({this.skey,this.onSignedIn});

  @override
  _LoginPageState createState() => _LoginPageState(skey);
}

class _LoginPageState extends State<LoginPage> implements LoginViewContract{
  Size size;
  LoginPresenter _presenter;
  bool _isLoading = false;
  Token token;


  GlobalKey<ScaffoldState> _scaffoldKey;


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }

  _LoginPageState(GlobalKey<ScaffoldState> skey) {
    _presenter = new LoginPresenter(this);
    _scaffoldKey = skey;
  }

  @override
  void onLoginError(String msg) {
    setState(() {
      _isLoading = false;
    });
    // showInSnackBar(msg);
  }


  @override
  void onLoginScuccess(Token t) {
    setState(() {
      _isLoading = false;
      token = t;
    });
    // showInSnackBar('Login successful');
    createInstaUser();
    widget.onSignedIn();

  }

  createInstaUser() async {
    try {
      final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
        functionName: 'createNewUser',
      );
      dynamic resp = callable.call(<String, dynamic>{
        'username': token.username,
        'displayName': token.full_name,
        'photoURL': token.profile_picture,
        'id': token.id
      });
      debugPrint(resp.toString());
    } catch (e) {
      debugPrint("Exception : $e");
    }
  }


  @override
  void initState() {
    super.initState();
  }

  void _handleFacebookLogin() async {
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
    var widget;
    if (_isLoading) {
      widget = new Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: new CircularProgressIndicator(),
      );
    } else {
      widget = Scaffold(
          appBar: AppBar(
            title: Text("Sign in"),
          ),
          body: _buildBody());
    }
    return widget;
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
          _handleFacebookLogin();
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
        onPressed: _handleInstagramLogin,
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

  void _handleInstagramLogin() {
    setState(() {
      _isLoading = true;
    });
    _presenter.performLogin();
  }
}
