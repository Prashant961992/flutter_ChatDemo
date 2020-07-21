import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ChannelAuth {
  Future<void> cretatePrivateChannels(String name, List<Users> users);
  
  Future<void> cretatePublicChannels(String name);

  Future<FirebaseUser> getCurrentUser();
}

class FirebaseChannels implements ChannelAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> cretatePrivateChannels(String name, List<Users> users) async {
    getCurrentUser().then((user) {
      if (users.length == 2) {
        createChannel(user, 1, users,"");
      } else {
        createChannel(user, 2, users,name);
      }
    });
  }
  
  Future<void> cretatePublicChannels(String name) async {
    getCurrentUser().then((user) {
      createChannel(user,0, List(),name);
    });
  }

  Future<void> createChannel(FirebaseUser logInUser, int channelType, List<Users> users, String channelName) async {
    if (channelType == 0) {
      Firestore.instance.collection(pPublicChannels).add({
        "creation-date": DateTime.now().millisecondsSinceEpoch.toString()
      });
    }

    firestoreInstance.collection(pCollectionChannels).add({
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
    }).then((value) {
      for (var user in users) {
        if (user.uid == logInUser.uid) {
          firestoreInstance
              .collection(pCollectionChannels)
              .document(value.documentID)
              .collection(pchannelUsers)
              .document(user.uid)
              .setData({"status": "owner"});
        } else {
          firestoreInstance
              .collection(pCollectionChannels)
              .document(value.documentID)
              .collection(pchannelUsers)
              .document(user.uid)
              .setData({"status": "member"});
        }

        firestoreInstance
            .collection(pCollectionUsers)
            .document(user.uid)
            .collection(pCollectionChannels)
            .document(value.documentID)
            .setData({"invitedBy": logInUser.uid});
      }
    });
  }
 
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }
}
