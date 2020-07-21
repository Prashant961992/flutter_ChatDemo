import 'package:chatdemo/models/UserChannels.dart';
import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/pages/ContactsPage.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/services/FirebaseAuthorization.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<UserChannels> _userChannelList;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Users _userData;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  void initState() {
    super.initState();

    _userChannelList = new List();
    this.getCurrentUser().then((user) {
      Firestore.instance
          .collection(pCollectionUsers)
          .document(user.uid)
          .snapshots(includeMetadataChanges: true)
          .listen(currentUserData);

      Firestore.instance
          .collection(pCollectionUsers)
          .document(user.uid)
          .collection(pCollectionChannels)
          .snapshots(includeMetadataChanges: true)
          .listen(onEntryAdded);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  currentUserData(DocumentSnapshot event) {
    _userData = Users.fromJson(event.data, event.documentID);
    print(_userData.toJson());
  }

  onEntryAdded(QuerySnapshot event) {
    _userChannelList = new List();
    var channelList = new List();
    setState(() {
      for (var i = 0; i < event.documents.length; i++) {
        channelList.add(event.documents[i].documentID);
        _userChannelList.add(UserChannels.fromJson(
            event.documents[i].data, event.documents[i].documentID));
      }
    });
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  Widget showTodoList() {
    if (_userChannelList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _userChannelList.length,
          itemBuilder: (BuildContext context, int index) {
            String subject = _userChannelList[index].channelId;
            return Dismissible(
              key: Key(subject),
              background: Container(color: Colors.red),
              onDismissed: (direction) async {},
              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            );
          });
    } else {
      return Center(
          child: Text(
        "Welcome. Your list is empty",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 30.0),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Flutter login demo'),
          actions: <Widget>[
            new FlatButton(
                child: new Text('Logout',
                    style: new TextStyle(fontSize: 17.0, color: Colors.white)),
                onPressed: signOut)
          ],
        ),
        body: showTodoList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ContactsPage()),
            );
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }
}
