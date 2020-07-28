import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebaseChannels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef StringValue = String Function(String);

class ContactsPage extends StatefulWidget {
  final VoidCallback onCountSelected;
  
  final Function(String) onCountChange;

  ContactsPage({
    Key key,
    this.onCountChange,
    this.onCountSelected
    }) : super(key: key);

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Contacts'),
        ),
        body: showContactList(),
      ),
    );
  }

  Widget showContactList() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: AppData.sharedInstance.users.length,
        itemBuilder: (BuildContext context, int index) {
          Users userData = AppData.sharedInstance.users[index];
          String name = AppData.sharedInstance.users[index].meta.name;
          // bool completed = AppData.sharedInstance.users[index].online;
          return InkWell(
            onTap: () {
              var arrData = AppData.sharedInstance.userOppsiteChannelList
                  .where((element) => element.id == userData.uid)
                  .toList();
              if (arrData.length == 0) {
                _selectedUserList.add(userData);
                FirebaseChannels()
                    .cretatePrivateChannels("", _selectedUserList);
              } else {
                Navigator.pop(context, arrData.first.channelId);
                // widget.onCountChange(arrData.first.channelId);
              }
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQ6iWic-5CDffrEPmSu8oi_cGzXd7EWVoaz6A&usqp=CAU"),
              ),
              title: Text(
                name,
                style: TextStyle(fontSize: 20.0),
              ),
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
