import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/StateProvider.dart';
import 'package:chatdemo/models/Channels.dart';
import 'package:chatdemo/pages/ChatPage.dart';
import 'package:chatdemo/pages/ContactsPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:chatdemo/services/FirebaseAuthorization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication/index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> with StateListener {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var stateProvider = new StateProvider();

  @override
  void initState() {
    super.initState();
    stateProvider.subscribe(this);
  }

  @override
  void dispose() {
    super.dispose();
    stateProvider.dispose(this);
  }

  @override
  void onStateChanged(ObserverState state) {
    switch (state) {
      case ObserverState.CHANNEL_LIST:
        setState(() {});
        break;
      default:
    }
  }

  signOut() async {
    BlocProvider.of<AuthenticationBloc>(context).add(
      AuthenticationLoggedOut(),
    );
  }

  String getname(Channels cData) {
    if (cData.meta.type == 1) {
      if (AppData.sharedInstance.users.length > 0) {
        var udata =
            cData.users.where((element) => element != widget.userId).toList();
        if (udata.length > 0) {
          var data = AppData.sharedInstance.users
              .where((element) => element.uid == udata.first);
          return data.first.meta.name;
        } else {
          return "Thread";
        }
      } else {
        return "Thread";
      }
    } else {
      return cData.meta.name;
    }
  }

  Widget showTodoList() {
    return ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        // shrinkWrap: true,
        itemCount: AppData.sharedInstance.userChannel.length,
        itemBuilder: (BuildContext context, int index) {
          Channels channelData = AppData.sharedInstance.userChannel[index];
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                          title: getname(channelData),
                          channelId: channelData.id,
                        )),
              );
            },
            child: ListTile(
              title: Text(
                getname(channelData),
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
          );
        });
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
            _pushToContact(context);
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ));
  }

  _pushToContact(BuildContext context) async {
    final id = await Navigator.push(
        context,
        CupertinoPageRoute(
            fullscreenDialog: true, builder: (context) => ContactsPage()));

    var arrData = AppData.sharedInstance.userChannel
        .where((element) => element.id == id)
        .toList();
    if (arrData.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  title: getname(arrData.first),
                  channelId: id,
                )),
      );
    }
  }
}
