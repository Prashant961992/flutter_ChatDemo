import 'dart:async';
import 'dart:io';

import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:rxdart/rxdart.dart';

import 'StateProvider.dart';
import 'models/Channels.dart';
import 'models/OppositeUser.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

abstract class Blocs {
  void dispose();
}

class AppData implements Blocs {
  AppData._();
  static final AppData instance = AppData._();
  // static AppData get instance => AppData();
  var currentUserdata = Users();
  String currentUserId = "";
  List<Users> users = [];
  List<Channels> chennelsList = [];
  List<OppositeUser> userOppsiteChannelList = [];

  BehaviorSubject<List<Users>> usersList = new BehaviorSubject<List<Users>>();
  BehaviorSubject<List<Channels>> channelStream =
      new BehaviorSubject<List<Channels>>();

  StreamSubscription<QuerySnapshot> firebasestreamSubuser;
  StreamSubscription<QuerySnapshot> firebasestreamSubChannel;

  @override
  void dispose() {
    firebasestreamSubuser.cancel();
    firebasestreamSubChannel.cancel();
    usersList.close();
    channelStream.close();
  }

  void startListner() {

    firebasestreamSubuser = Firestore.instance.collection(pCollectionUsers)
        .snapshots(includeMetadataChanges: true)
        .listen(currentUserFirebaseData);

    firebasestreamSubChannel = Firestore.instance
        .collection(pCollectionChannels)
        .where(pchannelUsers, arrayContainsAny: [currentUserId])
        .snapshots(includeMetadataChanges: true)
        .listen(currentChannelFirebaseData);
   
    // Firestore.instance
    //     .collection(pCollectionUsers)
    //     .snapshots(includeMetadataChanges: true)
    //     .listen(currentUserData);

    // Firestore.instance
    //     .collection(pCollectionChannels)
    //     .where(pchannelUsers, arrayContainsAny: [currentUserId])
    //     .snapshots(includeMetadataChanges: true)
    //     .listen(currentChannelData);
  }

  void currentUserFirebaseData(QuerySnapshot event) {
    var documentsdata = event.documents;
    List<Users> usersLists = [];
    for (var items in documentsdata) {
      usersLists.add(Users.fromJson(items.data, items.documentID));
    }

    var udata = usersLists.where((element) => element.uid == currentUserId);
    AppData.instance.currentUserdata = udata.first;
    AppData.instance.currentUserId = currentUserId;
    usersLists.removeWhere((element) => element.uid == currentUserId);
    AppData.instance.users = usersLists;
    
    if (!usersList.isClosed)  {
       usersList.sink.add(usersLists);
    } else {
      print("Controller is closed");
    }
    
  }

  void currentChannelFirebaseData(QuerySnapshot event) {
    var documentsdata = event.documents;
    List<Channels> usersChannelList = [];
    for (var items in documentsdata) {
      usersChannelList.add(Channels.fromJson(items.data, items.documentID));
    }

    userOppsiteChannelList = [];
    for (var i = 0; i < usersChannelList.length; i++) {
      var cData = usersChannelList[i];
      var udata =
          cData.users.where((element) => element != currentUserId).toList();
      if (udata.length > 0) {
        var data = users.where((element) => element.uid == udata.first);
        userOppsiteChannelList
            .add(OppositeUser(id: data.first.uid, channelId: cData.id));
      }
    }
    AppData.instance.chennelsList = usersChannelList;
    
    if (!channelStream.isClosed)  {
       channelStream.sink.add(usersChannelList);
    } else {
      print("Controller is closed");
    }
  }

  String getname(Channels cData) {
    if (cData.meta.type == 1) {
      if (AppData.instance.users.length > 0) {
        var udata = cData.users
            .where((element) => element != this.currentUserId)
            .toList();
        if (udata.length > 0) {
          var data = AppData.instance.users
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

  String getImage(Channels cData) {
    if (cData.meta.type == 1) {
      if (AppData.instance.users.length > 0) {
        var udata = cData.users
            .where((element) => element != this.currentUserId)
            .toList();
        if (udata.length > 0) {
          var data = AppData.instance.users
              .where((element) => element.uid == udata.first);
          return data.first.meta.photoUrl;
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

  Future<void> makeOnline(bool status, String id) async {
    return Future.wait([
      Firestore.instance.collection(pCollectionUsers).document(id).updateData(
          {'online': status, 'last-online': FieldValue.serverTimestamp()})
    ]);
  }

  Future<void> updateProfile(Users userInfo) async {
    var user = userInfo.uid;
    var jsonInfo = userInfo.toJson();
    jsonInfo.remove("uid");

    return Future.wait([
      Firestore.instance
          .collection(pCollectionUsers)
          .document(user)
          .updateData(jsonInfo)
    ]);
  }

  Future<String> uploadFile(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);

    File compressedFile = await FlutterNativeImage.compressImage(imageFile.path,
        quality: 80, percentage: 90);

    StorageUploadTask uploadTask = reference.putFile(compressedFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;
    return storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      return downloadUrl;
    });
  }
}
