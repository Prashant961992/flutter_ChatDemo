import 'package:chatdemo/models/Users.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatdemo/services/FirebseConstants.dart';

class FirebaseMessages {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // ignore: missing_return
  //, List<Users> users
  Future<void> sendMessage(
      String message, String channelId, List<Users> users) {
    List<String> userl = [];
    for (var i = 0; i < users.length; i++) {
      userl.add(users[i].uid);
    }

    getCurrentUser().then((user) {
      firestoreInstance
          .collection(pCollectionChannels)
          .document(channelId)
          .collection(pchannelmessages)
          .add({
        "date": FieldValue.serverTimestamp(),
        "from": user.email,
        "meta": {"text": message},
        "to": FieldValue.arrayUnion(userl),
        // "to" : FieldValue.arrayUnion([{"uid":"","name":"p"},{"uid":"","name":"p"}]),
        "type": "text", //message type e.g. text , image , video
        "user-firebase-id": user.uid,
      }).then((value) {
        // lastMessage
        firestoreInstance
            .collection(pCollectionChannels)
            .document(channelId)
            .updateData({
              "lastMessage" : {
          "date": FieldValue.serverTimestamp(),
          "from": user.email,
          "meta": {"text": message},
          // "to": FieldValue.arrayUnion(userl),
          // "to" : FieldValue.arrayUnion([{"uid":"","name":"p"},{"uid":"","name":"p"}]),
          "type": "text", //message type e.g. text , image , video
          "user-firebase-id": user.uid,
        }
            });
        // Mofidify user
        // firestoreInstance
        //   .collection(pCollectionChannels)
        //   .document(channelId)
        //   .collection(pchannelmessages)
        //   .document(value.documentID)
        //   .collection(pchannelRead)
        //   .add({
        //      "date": DateTime.now().millisecondsSinceEpoch.toString(),
        //      "status": 2
        //   });
      });
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
}
