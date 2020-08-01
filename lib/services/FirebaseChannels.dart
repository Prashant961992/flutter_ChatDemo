import '../models/Users.dart';
import '../services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ChannelAuth {
  Future<String> cretatePrivateChannels(String name, List<Users> users);

  Future<String> cretatePublicChannels(String name);

  Future<FirebaseUser> getCurrentUser();
}

class FirebaseChannels implements ChannelAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
 
  Future<String> cretatePrivateChannels(String name, List<Users> users) async {
    final user = await getCurrentUser();
    if (users.length == 2) {
      return createChannel(user, 1, users, "").then((value) {
         return value;
      });
    } else {
      return createChannel(user, 2, users, name == "" ? "Group" : name).then((value) {
        return value;
      });
    }
  }

  Future<String> cretatePublicChannels(String name) async {
    final user = await getCurrentUser();
    return createChannel(user, 0, List(), name);
  }

  Future<String> createChannel(FirebaseUser logInUser, int channelType,
      List<Users> users, String channelName) async {
    if (channelType == 0) {
      Firestore.instance.collection(pPublicChannels).add(
          {"creation-date": DateTime.now().millisecondsSinceEpoch.toString()});
    }

    List<String> user = [];
    for (var i = 0; i < users.length; i++) {
      user.add(users[i].uid);
    }

    List<Map> userInfo = [];
    for (var i = 0; i < users.length; i++) {
      var mapData = Map();
      mapData["uid"] = users[i].uid;
      if (users[i].uid == logInUser.uid) {
        mapData["status"] = "owner";
      } else {
        mapData["status"] = "member";
      }
      userInfo.add(mapData);
    }

    return firestoreInstance.collection(pCollectionChannels).add({
      "details": {
        "creation-date": DateTime.now().millisecondsSinceEpoch.toString(),
        "creator": logInUser.email,
        "creator-entity-id": logInUser.uid,
        "name": channelName,
        "type": channelType,
      },
      "meta": {
        "creation-date": DateTime.now().millisecondsSinceEpoch.toString(),
        "creator": logInUser.email,
        "creator-entity-id": logInUser.uid,
        "name": channelName,
        "type": channelType,
      },
      "users": FieldValue.arrayUnion(user),
      "usersInfo": FieldValue.arrayUnion(userInfo)
    }).then((value) {
      // for (var user in users) {
      //   firestoreInstance
      //       .collection(pCollectionUsers)
      //       .document(user.uid)
      //       .collection(pCollectionChannels)
      //       .document(value.documentID)
      //       .setData({"invitedBy": logInUser.uid});
      // }
      return value.documentID;
    });
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
}
