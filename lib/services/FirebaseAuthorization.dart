import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'FirebseConstants.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    //await checkUserExists(user);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    await checkUserExists(user);
    return user.uid;
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  static Future<void> checkUserExists(FirebaseUser logInUser) async {
    final QuerySnapshot result = await Firestore.instance
        .collection(pCollectionUsers)
        .where('userId', isEqualTo: logInUser.uid)
        .getDocuments();
    final List<DocumentSnapshot> documents = result.documents;
    if (documents.length == 0) {
      // Update data to server if new user
      await saveNewUser(logInUser);
    }
  }

  static saveNewUser(FirebaseUser logInUser) {
    Firestore.instance
        .collection(pCollectionUsers)
        .document(logInUser.uid)
        .setData({
      "meta" : {
      "availability" : "",
      "email" : logInUser.email,
      "locality": "",
      "name": logInUser.email,
      "name-lowercase": "",
      "phone": "",
      "photoUrl": "",
      "status": "",
      'createdAt': FieldValue.serverTimestamp(),
     },
     'online': false,
     'last-online': FieldValue.serverTimestamp()
    });
  }

}
