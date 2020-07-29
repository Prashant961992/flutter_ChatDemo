import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebaseChannels.dart';
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
        stream: AppData.instance.usersList.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                separatorBuilder: (context, index) => Divider(),
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Users userData = snapshot.data[index];
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
                      height: 50,
                      child: ListTile(
                        leading: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: userData.meta.photoUrl,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                Image.asset('assets/defaultavatar.jpg'),
                          ),
                        ),
                        title: Text(
                          userData.meta.name,
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return Center(
              child: LoadingIndicator(),
            );
          }
        });
  }
}
