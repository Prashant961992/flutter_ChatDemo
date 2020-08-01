import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebaseChannels.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../LoadingIndicator.dart';

typedef StringValue = String Function(String);

class ContactsPage extends StatefulWidget {
  final VoidCallback onCountSelected;

  final Function(String) onCountChange;

  ContactsPage({Key key, this.onCountChange, this.onCountSelected})
      : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Users> _selectedUserList;

  @override
  void initState() {
    super.initState();

    _selectedUserList = new List();
    _selectedUserList.add(AppData.instance.currentUserdata);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Pick Friends'),
        ),
        body: showContactList(),
      ),
    );
  }

  Widget showContactList() {
    return StreamBuilder(
        stream: Firestore.instance
            .collection(pCollectionUsers)
            .where(AppData.instance.currentUserId)
            .snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                // separatorBuilder: (context, index) => Divider(),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Users userData = Users.fromJson(
                      snapshot.data.documents[index].data,
                      snapshot.data.documents[index].documentID);
                  if (userData.uid != AppData.instance.currentUserId) {
                    return InkWell(
                      onTap: () {
                        var arrData = AppData.instance.userOppsiteChannelList
                            .where((element) => element.id == userData.uid)
                            .toList();
                        if (arrData.length == 0) {
                          _selectedUserList.add(userData);
                          FirebaseChannels()
                              .cretatePrivateChannels("", _selectedUserList)
                              .then((value) {
                            Navigator.pop(context, value);
                          });
                        } else {
                          Navigator.pop(context, arrData.first.channelId);
                        }
                      },
                      child: SizedBox(
                        height: 72,
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                radius: 20,
                                child: ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: userData.meta.photoUrl,
                                    width: 150,
                                    height: 150,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Image.asset('assets/defaultavatar.jpg'),
                                  ),
                                ),
                              ),
                              trailing: Text(
                                  userData.online == true ? "Online" : "Offline"),
                              title: Text(
                                userData.meta.name,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            ),
                            Divider()
                          ],
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 0,
                    );
                  }
                });
          } else {
            return Center(
              child: LoadingIndicator(),
            );
          }
        });
  }
}
