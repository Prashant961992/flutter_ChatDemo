import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebaseChannels.dart';
import 'package:chatdemo/services/FirebaseMessages.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactsPage extends StatefulWidget {
  ContactsPage({Key key}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  List<Users> _userList;
  List<Users> _selectedUserList;
  Users _userData;

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  @override
  void initState() {
    super.initState();

    _userList = new List();
    _selectedUserList = new List();

    Firestore.instance
        .collection(pCollectionChannels)
        .document("QVY47vgHBkYiW4nL8FEm")
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      print(event);
    });

    Firestore.instance
          .collection(pCollectionChannels)
          .document("QVY47vgHBkYiW4nL8FEm")
          .collection(pchannelmessages)
          .snapshots(includeMetadataChanges: true)
          .listen((event) {
        print(event);
      });
  
    this.getCurrentUser().then((user) {
      Firestore.instance
          .collection(pCollectionUsers)
          .document(user.uid)
          .snapshots(includeMetadataChanges: true)
          .listen(currentUserData);

      Firestore.instance
          .collection(pCollectionUsers)
          .snapshots(includeMetadataChanges: true)
          .listen(onEntryAdded);
    });

    // Firestore.instance.collection(pCollectionUsers).snapshots(includeMetadataChanges: true).listen(onEntryAdded);
  }

  @override
  void dispose() {
    super.dispose();
  }

  currentUserData(DocumentSnapshot event) {
    _userData = Users.fromJson(event.data, event.documentID);
    _selectedUserList.add(_userData);
    print(_userData.toJson());
  }

  onEntryAdded(QuerySnapshot event) {
    _userList = new List();
    setState(() {
      for (var i = 0; i < event.documents.length; i++) {
        _userList.add(Users.fromJson(
            event.documents[i].data, event.documents[i].documentID));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Contacts'),
        ),
        body: showTodoList(),
      ),
    );
  }

  Widget showTodoList() {
    if (_userList.length > 0) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: _userList.length,
          itemBuilder: (BuildContext context, int index) {
            String subject = _userList[index].displayName;
            bool completed = _userList[index].online;
            return InkWell(
              // key: Key(subject),
              onTap: () {
                // FirebaseMessages().sendMessage("Hello","QVY47vgHBkYiW4nL8FEm");
                _selectedUserList.add(_userList[index]);
                FirebaseChannels().cretatePrivateChannels("",_selectedUserList);
              },
              child: ListTile(
                title: Text(
                  subject,
                  style: TextStyle(fontSize: 20.0),
                ),
                trailing: IconButton(
                    icon: (completed)
                        ? Icon(
                            Icons.done_outline,
                            color: Colors.green,
                            size: 20.0,
                          )
                        : Icon(Icons.done, color: Colors.grey, size: 20.0),
                    onPressed: () {
                      // updateTodo(_todoList[index]);
                    }),
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
}
