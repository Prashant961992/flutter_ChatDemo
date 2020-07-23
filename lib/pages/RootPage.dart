import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/pages/LoginSignupPage.dart';
import 'package:chatdemo/services/FirebaseAuthorization.dart';
import 'package:chatdemo/pages/HomePage.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      if (user != null) {
        AppData.sharedInstance.currentUserId = user?.uid;
        _userId = user?.uid;
      }
      authStatus =
          user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;

      Firestore.instance
          .collection(pCollectionUsers)
          .snapshots(includeMetadataChanges: true)
          .listen(currentUserData);
    });
  }

  void currentUserData(QuerySnapshot event) {
    var documentsdata = event.documents;
    List<Users> usersList = [];
    for (var items in documentsdata) {
      usersList.add(Users.fromJson(items.data, items.documentID));
    }

    var udata = usersList.where((element) => element.uid == _userId);
    AppData.sharedInstance.currentUserdata = udata.first;
    usersList.removeWhere((element) => element.uid == _userId);
    AppData.sharedInstance.users = usersList;

    setState(() {});
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      if (user != null) {
        AppData.sharedInstance.currentUserId = user?.uid;
        _userId = user?.uid;
      }
      authStatus =
          user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      
      Firestore.instance
          .collection(pCollectionUsers)
          .snapshots(includeMetadataChanges: true)
          .listen(currentUserData);
    });

    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}
