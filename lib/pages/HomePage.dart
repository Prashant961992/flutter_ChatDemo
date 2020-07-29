import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/Channels.dart';
import '../pages/ChatPage.dart';
import '../pages/ContactsPage.dart';
import '../index.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key})
      : super(key: key);

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
          tooltip: 'Increment',
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
                // shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Channels channelData = snapshot.data[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  title: AppData.instance
                                      .getname(channelData)
                                      .toString(),
                                  channelId: channelData.id,
                                )),
                      );
                    },
                    child: ListTile(
                      subtitle: Text('Last message'),
                      title: Text(
                        AppData.instance.getname(channelData).toString(),
                        style: TextStyle(fontSize: 20.0, color: Colors.black),
                      ),
                      leading: ClipOval(
                          child: CachedNetworkImage(
                        imageUrl: AppData.instance.getImage(channelData),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/defaultavatar.jpg'),
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
