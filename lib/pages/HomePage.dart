import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/Channels.dart';
import '../pages/ChatPage.dart';
import '../pages/ContactsPage.dart';
import '../index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Chat'),
        ),
        body: showChannelList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _pushToContact(context);
          },
          child: Icon(Icons.add),
        ));
  }

  Widget showChannelList() {
    return StreamBuilder(
        stream: AppData.instance.channelStream.stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Channels channelData = snapshot.data[index];
                  return InkWell(
                    onTap: () async {
                      var data = await AppData.instance.displayname(channelData);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  title: data,
                                  channelId: channelData.id,
                                )),
                      );
                    },
                    child: ListTile(
                      title: FutureBuilder(
                        future: AppData.instance.displayname(channelData),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data,
                              style: TextStyle(
                                  fontSize: 20.0, color: Colors.black),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                      // subtitle: channelData.lastmessage.lastMessahemeta?.text == null ? Text("Last") : Text(channelData.lastmessage.lastMessahemeta?.text == null ? "" : channelData.lastmessage.lastMessahemeta?.text),
                      leading: CircleAvatar(
                          radius: 25,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: AppData.instance.getImage(channelData),
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                                  Image.asset('assets/defaultavatar.jpg'),
                            ),
                          )),
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

  _pushToContact(BuildContext context) async {
    final id = await Navigator.push(
        context,
        MaterialPageRoute(
            fullscreenDialog: true, builder: (context) => ContactsPage()));

    var arrData = AppData.instance.chennelsList
        .where((element) => element.id == id)
        .toList();
    if (arrData.length > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatPage(
                  title: AppData.instance.getname(arrData.first).toString(),
                  channelId: id,
                )),
      );
    }
  }
}
