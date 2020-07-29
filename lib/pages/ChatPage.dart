import 'package:chatdemo/AppData.dart';
import 'package:chatdemo/services/FirebaseMessages.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String channelId;
  final String title;

  ChatPage({this.channelId,this.title});
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textFieldMessage = TextEditingController();
 
  _buildMessage(Map message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 80.0,
            )
          : EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
            ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "00:00",
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            message["meta"]["text"],
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: Icon(Icons.favorite),
          // icon: message.isLiked
          //     ? Icon(Icons.favorite)
          //     : Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: Colors.blueGrey,
          // message.isLiked
          //     ? Theme.of(context).primaryColor
          //     : Colors.blueGrey,
          onPressed: () {},
        )
      ],
    );
  }

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
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                    child: StreamBuilder(
                      stream: Firestore.instance
                          .collection(pCollectionChannels)
                          .document(widget.channelId)
                          .collection(pchannelmessages).orderBy("date",descending: true)
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
                                return _buildMessage(message, true);
                              } else {
                                return _buildMessage(message, false);
                              }
                            },
                          );
                        } else {
                          return Center(
                            child: CircularProgressIndicator()
                          );
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

  // Widget buildMessageTextField() {
  //   return Container(
  //     child: Container(
  //       height: 50.0,
  //       child: Row(
  //         children: <Widget>[
  //           Expanded(
  //             child: TextField(
  //               controller: textEditingController,
  //               decoration: InputDecoration(
  //                 border: InputBorder.none,
  //                 hintText: 'Write your reply...',
  //                 hintStyle: TextStyle(
  //                   fontSize: 16.0,
  //                   color: Color(0xffAEA4A3),
  //                 ),
  //               ),
  //               textInputAction: TextInputAction.send,
  //               style: TextStyle(
  //                 fontSize: 16.0,
  //                 color: Colors.black,
  //               ),
  //               onSubmitted: (_) {
  //                 // addNewMessage();
  //               },
  //             ),
  //           ),
  //           Container(
  //             width: 50.0,
  //             child: InkWell(
  //               onTap: addNewMessage,
  //               child: Icon(
  //                 Icons.send,
  //                 color: Color(0xFFdd482a),
  //               ),
  //             ),
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return new Scaffold(
  //     appBar: AppBar(
  //       title: Text("Chat"),
  //       centerTitle: true,
  //     ),
  //     body: Stack(
  //       children: <Widget>[
  //         Column(
  //           children: <Widget>[
  //             // _appBar(),
  //             Flexible(
  //               child: ListView.builder(
  //                   itemCount: 50,
  //                   reverse: true,
  //                   itemBuilder: (BuildContext ctxt, int index) {
  //                     return Row(
  //                     children: <Widget>[
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         CircleAvatar(
  //                           radius: 30.0,
  //                           backgroundImage: NetworkImage("data:image/jpeg;base64,/9j/4AAQSkZJRgABAQAAAQABAAD/2wCEAAkGBwgHBgkIBwgKCgkLDRYPDQwMDRsUFRAWIB0iIiAdHx8kKDQsJCYxJx8fLT0tMTU3Ojo6Iys/RD84QzQ5OjcBCgoKDQwNGg8PGjclHyU3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3Nzc3N//AABEIAH4AdQMBIgACEQEDEQH/xAAbAAEAAwEBAQEAAAAAAAAAAAAABAUGAwIBB//EADUQAAIBAwIDBgIKAgMAAAAAAAABAgMEEQUSITFBEyJRcZHBYWIUMkJSgYKSobHR4fAVI3L/xAAUAQEAAAAAAAAAAAAAAAAAAAAA/8QAFBEBAAAAAAAAAAAAAAAAAAAAAP/aAAwDAQACEQMRAD8A/cQAAAAAES6v6FtmMpbp/djxZWVtYrzz2UY016sC+Bl53tzPnXqfg8HlXNdcq9T9bA1QM1T1G7p8qzl8JLJOt9Z44uKf5of0Bbg50a9OvHdSmpL4HQAAAAAAAAD42knl4XiUl/qkpt07Z4hyc+r8j7q97vm7ek+4vrNdX4FWAPUISqSUYRcpPkkeTR6dZwtqKbX/AGSWZP2Ar6OjVZRTq1Iwb6JZOr0RdLh/p/yW4Az1xpdxRy4pVI/Lz9CCa8oNXtOwrdrBdyo+XgwIVGrUoz30pOMvEvtPv43S2SxGqlxXj5GePsZOElKLaa4poDXAiaddq6o5fCpHhJe5LAAAARNSufo1rKUX35d2PmSyh1yrvuY0s8ILl8X/AKgK4AAdLeO+4pQ+9NL9zVIzFhGU72iorOJp+nH2NQgAAAEHWYqVjN4+q01649ycRdUjKdjWUVl4z6PIGaAAHexuHbXEan2eUl8DUJprKMgaPSq3bWUG3lx7r/ACYAABl7+W+8rP52jUGVu1i6rf+3/IHIAASdNlsvqL8ZY9eBpjIxk4yUovDTyjS6fcu6t+0lFRabTSAkgAARtRnssqz+XHrwJJS61dSc3bJJRWG34gVQAAFzoEu5Wi+jTKYttA51/y+4FyAABmtUhsvqvzPd6mlKfXqPCnXXTuy9gKgAAC20Gs91Si/Dev4fsVJd6LaqFL6TLO+aaS+AFoAABlbqr29xOr958PI1RmtRtVaXGyOdklmOQIoAAF5oUNtvUnj60v4KPm0lzfBGos6PYW1Ol1iuPmB3AAA516Ua9GdOfKSwdABk61KVGrKnNYlFng0WoWMbtRaajUjyljoebXS6NBqUs1J/MuC/ACtsdNqV5KVWMoU+eerL+EVCCjFYSWEj0AAAAEW+s43dPDeJR+qyUAMrXt6tu8VoOPg+jORrKtOFWDhUipRfRlZV0WDlmlVcY54qSyBH0e1dWt20l3KfL4svjxRpRo01TprEY8j2AAAAAAAAAAAAAAAAAAAAAAAAAAAHzcs46jJAq6ZCrczryq1E5NNJfZfDl6HB6JCUlKVzUdRR278LLWZP3wBbZGfErJ6RTcIR7WfcznPe3eefJHn/hY9nKDuaz3dc8VjHLw5cfEC1yfSuuNM7dvdcVItxS7uFjGeXr6pM6W2nwtqs6kalRuecpvxx/X7sCXKcYvEpJebPLrUk8dpHPDhuXXkRfoCjG1hGrNq2i4xdR9pKS27e9J8X7nGOjwjRlS7ee2VOEJYWM7UlnzwkBYOvRTw6sE+POS6cx29HOO1hnhw3LryINDSoUYqKrVJKMpygpcdrksZ9M/qZ8jpFNRpqNWalTUFGf2ko56/Hc/UCxjKM1mElJeKeT0R7G2VrSlDdvcpuUpYxlskAAAB//Z"),
  //                         ),
  //                         SizedBox(width: 10.0),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             Text(
  //                               "Sender Name $index",
  //                               style: TextStyle(
  //                                 color: Colors.grey,
  //                                 fontSize: 15.0,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                             SizedBox(height: 5.0),
  //                             Container(
  //                               width: MediaQuery.of(context).size.width * 0.45,
  //                               child: Text(
  //                                 "Hello",
  //                                 style: TextStyle(
  //                                   color: Colors.blueGrey,
  //                                   fontSize: 15.0,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                                 overflow: TextOverflow.ellipsis,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     Column(
  //                       children: <Widget>[
  //                         Text(
  //                           "00:00",
  //                           style: TextStyle(
  //                             color: Colors.grey,
  //                             fontSize: 15.0,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         SizedBox(height: 5.0),
  //                         isRead
  //                             ? Container(
  //                                 width: 40.0,
  //                                 height: 20.0,
  //                                 decoration: BoxDecoration(
  //                                   color: Theme.of(context).primaryColor,
  //                                   borderRadius: BorderRadius.circular(30.0),
  //                                 ),
  //                                 alignment: Alignment.center,
  //                                 child: Text(
  //                                   'NEW',
  //                                   style: TextStyle(
  //                                     color: Colors.white,
  //                                     fontSize: 12.0,
  //                                     fontWeight: FontWeight.bold,
  //                                   ),
  //                                 ),
  //                               )
  //                             : Text(''),
  //                       ],
  //                     ),
  //                   ],
  //                     );
  //                   }),
  //             ),
  //             buildMessageTextField(),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
