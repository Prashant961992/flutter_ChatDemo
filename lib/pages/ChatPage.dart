import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/services/FirebaseMessages.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bubble/bubble.dart';

class ChatPage extends StatefulWidget {
  final String channelId;
  final String title;

  ChatPage({this.channelId, this.title});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textFieldMessage = TextEditingController();

  // _buildMessage(Map message, bool isMe) {
  //   final Container msg = Container(
  //     margin: isMe
  //         ? EdgeInsets.only(
  //             top: 8.0,
  //             bottom: 8.0,
  //             left: 80.0,
  //           )
  //         : EdgeInsets.only(
  //             top: 8.0,
  //             bottom: 8.0,
  //           ),
  //     padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
  //     width: MediaQuery.of(context).size.width * 0.75,
  //     decoration: BoxDecoration(
  //       color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
  //       borderRadius: isMe
  //           ? BorderRadius.only(
  //               topLeft: Radius.circular(15.0),
  //               bottomLeft: Radius.circular(15.0),
  //             )
  //           : BorderRadius.only(
  //               topRight: Radius.circular(15.0),
  //               bottomRight: Radius.circular(15.0),
  //             ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: <Widget>[
  //         Text(
  //           "00:00",
  //           style: TextStyle(
  //             color: Colors.blueGrey,
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //         SizedBox(height: 8.0),
  //         Text(
  //           message["meta"]["text"],
  //           style: TextStyle(
  //             color: Colors.blueGrey,
  //             fontSize: 16.0,
  //             fontWeight: FontWeight.w600,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  //   if (isMe) {
  //     return Bubble(
  //       //margin: BubbleEdges.only(top: 2),
  //       alignment: Alignment.topRight,
  //       //nip: BubbleNip.rightTop,
  //       color: Color.fromRGBO(225, 255, 199, 1.0),
  //       child: Text('How are you?', textAlign: TextAlign.right),
  //     );
  //   }
  //   return Row(
  //     children: <Widget>[
  //       msg,
  //       IconButton(
  //         icon: Icon(Icons.favorite),
  //         // icon: message.isLiked
  //         //     ? Icon(Icons.favorite)
  //         //     : Icon(Icons.favorite_border),
  //         iconSize: 30.0,
  //         color: Colors.blueGrey,
  //         // message.isLiked
  //         //     ? Theme.of(context).primaryColor
  //         //     : Colors.blueGrey,
  //         onPressed: () {},
  //       )
  //     ],
  //   );
  // }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.photo),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: textFieldMessage,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              if (textFieldMessage.text.length > 0) {
                FirebaseMessages()
                    .sendMessage(textFieldMessage.text, widget.channelId, []);
                textFieldMessage.text = "";
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double pixelRatio = MediaQuery.of(context).devicePixelRatio;
    double px = 1 / pixelRatio;

    BubbleStyle styleSomebody = BubbleStyle(
      nip: BubbleNip.leftTop,
      color: Colors.white,
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, right: 50.0),
      alignment: Alignment.topLeft,
    );

    BubbleStyle styleMe = BubbleStyle(
      nip: BubbleNip.rightBottom,
      color: Color.fromARGB(255, 225, 255, 199),
      elevation: 1 * px,
      margin: BubbleEdges.only(top: 8.0, left: 50.0),
      alignment: Alignment.topRight,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: 28.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0.0,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                color: Colors.white,
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.only(
                //     topLeft: Radius.circular(30.0),
                //     topRight: Radius.circular(30.0),
                //   ),
                // ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection(pCollectionChannels)
                          .document(widget.channelId)
                          .collection(pchannelmessages)
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: 15.0),
                            itemCount: snapshot.data.documents.length,
                            itemBuilder: (BuildContext context, int index) {
                              var message = snapshot.data.documents[index].data;

                              if (message["user-firebase-id"] ==
                                  AppData.instance.currentUserId) {
                                // return _buildMessage(message, true);
                                return Bubble(
                                  style: styleMe,
                                  child: Text(message["meta"]["text"]),
                                );
                              } else {
                                // return _buildMessage(message, false);
                                return Bubble(
                                  style: styleSomebody,
                                  child: Text(message["meta"]["text"]),
                                );
                              }
                            },
                          );
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      },
                    )),
              ),
            ),
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }
}
