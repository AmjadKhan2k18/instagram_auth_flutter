import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_auth/model/user_model.dart';

class Database {

  var db = Firestore.instance;
  
  setUserProfile(String userId,UserModel model) async{
    var userRef = db.collection('userProfile');
    userRef.document(userId).setData(model.toJson());
  }

  // Future<DocumentSnapshot> getUserProfile(String userId) async {
  //   var document = db.collection('userProfile').document(userId);
  //   var userProfile = await document.get();
  //   return userProfile;
  // }

}