import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/models/Channels.dart';
import 'package:chatdemo/models/UserChannels.dart';
import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/pages/ChatPage.dart';
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
  List<Channels> _userChannelList;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  void initState() {
    super.initState();

    // Firestore.instance
    //     .collection("channels")
    //     .where("users", arrayContains: "LYde7F1GIlf02LzQVUZvQvpTQ7p1")
    //     .snapshots()
    //     .listen((event) {
    //   print(event);
    // });

    _userChannelList = new List();

    // Firestore.instance
    //       .collection(pCollectionUsers)
    //       .document(AppData.sharedInstance.currentUserId)
    //       .snapshots(includeMetadataChanges: true)
    //       .listen(currentUserData);

    // Firestore.instance
    //     .collection(pCollectionUsers)
    //     .document(AppData.sharedInstance.currentUserId)
    //     .collection(pCollectionChannels)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen(onEntryAdded);

    // Firestore.instance
    //     .collection(pCollectionChannels)
    //     .where(pchannelUsers,
    //         arrayContainsAny: [AppData.sharedInstance.currentUserId])
    //     .snapshots(includeMetadataChanges: true)
    //     .listen(onEntryAdded);

    // .listen(onEntryAdded);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // onEntryAdded(QuerySnapshot event) {
  //   _userChannelList = new List();

  //   setState(() {
  //     for (var i = 0; i < event.documents.length; i++) {
  //       _userChannelList.add(Channels.fromJson(
  //           event.documents[i].data, event.documents[i].documentID));
  //     }
  //   });
  // }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  String getname(Channels cData) {
    if (cData.meta.type == 1) {
      var udata = cData.users
          .where((element) => element != AppData.sharedInstance.currentUserId);
      var data = AppData.sharedInstance.users
          .where((element) => element.uid == udata.first);
      return data.first.meta.name;
    } else {
      return cData.meta.name;
    }
  }

  Widget showTodoList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection(pCollectionChannels)
            .where(pchannelUsers, arrayContainsAny: [
          AppData.sharedInstance.currentUserId
        ]).snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Channels channelData = Channels.fromJson(
                      snapshot.data.documents[index].data,
                      snapshot.data.documents[index].documentID);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ChatPage(
                          title: getname(channelData),
                          channelId: channelData.id,
                        )),
                      );
                    },
                    child: ListTile(
                      title: Text(getname(channelData),
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                    ),
                  );
                });
          } else {
            return CircularProgressIndicator();
          }
        });

    //     return Center(
    //     child: Text(
    //   "Welcome. Your list is empty",
    //   textAlign: TextAlign.center,
    //   style: TextStyle(fontSize: 30.0),
    // ));
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
