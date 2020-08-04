import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  void initState() {
    super.initState();

    Firestore.instance
        .collectionGroup(pCollectionChannels)
        .where(FieldPath.documentId, isEqualTo: "8WCMxc3cbC0BvzUSL7AK")
        .getDocuments()
        .then((value) {
      print(value);
    }).catchError((error) {
        print(error);
    });
//     Firestore.instance
//         .collectionGroup(pCollectionChannels).getDocuments().then((value) {
//             print(value);
//         });
  }

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
        stream: Firestore.instance
            .collection(pCollectionChannels)
            .where(pchannelUsers, arrayContainsAny: [
          AppData.instance.currentUserId
        ]).snapshots(includeMetadataChanges: true),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (BuildContext context, int index) {
                  Channels channelData = Channels.fromJson(
                      snapshot.data.documents[index].data,
                      snapshot.data.documents[index].documentID);
                  return InkWell(
                    onTap: () async {
                      var data =
                          await AppData.instance.displayname(channelData);
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
