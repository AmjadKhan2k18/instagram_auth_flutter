import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> currentUser();
  Future<void> signOut();
}


class Auth extends BaseAuth {
 


  Future<String> currentUser() async
  {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.uid;
  }

  Future<void> signOut() async
  {
    return FirebaseAuth.instance.signOut();
  }
}