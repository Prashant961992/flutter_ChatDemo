import 'package:chatdemo/AppData.dart';
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
  List<Users> _selectedUserList;

  @override
  void initState() {
    super.initState();

    _selectedUserList = new List();
    _selectedUserList.add(AppData.sharedInstance.currentUserdata);

    // this.getCurrentUser().then((user) {
    //   Firestore.instance
    //       .collection(pCollectionUsers)
    //       .document(user.uid)
    //       .snapshots(includeMetadataChanges: true)
    //       .listen(currentUserData);

    //   Firestore.instance
    //       .collection(pCollectionUsers)
    //       .snapshots(includeMetadataChanges: true)
    //       .listen(onEntryAdded);
    // });
  }

  @override
  void dispose() {
    super.dispose();
  }

  // currentUserData(DocumentSnapshot event) {
  //   _userData = Users.fromJson(event.data, event.documentID);

  //   print(_userData.toJson());
  // }

  // onEntryAdded(QuerySnapshot event) {
  //   _userList = new List();
  //   setState(() {
  //     for (var i = 0; i < event.documents.length; i++) {
  //       _userList.add(Users.fromJson(
  //           event.documents[i].data, event.documents[i].documentID));
  //     }
  //   });
  // }

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
    return ListView.builder(
        shrinkWrap: true,
        itemCount: AppData.sharedInstance.users.length,
        itemBuilder: (BuildContext context, int index) {
          Users userData = AppData.sharedInstance.users[index];
          String subject = AppData.sharedInstance.users[index].meta.name;
          bool completed = AppData.sharedInstance.users[index].online;
          return InkWell(
            onTap: () {
              _selectedUserList.add(userData);
              FirebaseChannels().cretatePrivateChannels("", _selectedUserList);
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

    // if (_userList.length > 0) {

    // } else {
    //   return Center(
    //       child: Text(
    //     "Welcome. Your list is empty",
    //     textAlign: TextAlign.center,
    //     style: TextStyle(fontSize: 30.0),
    //   ));
    // }
  }
}
