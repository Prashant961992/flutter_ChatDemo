import 'package:chatdemo/models/Users.dart';
import 'package:chatdemo/services/FirebseConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'StateProvider.dart';
import 'models/Channels.dart';
import 'models/OppositeUser.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class AppData {
  AppData._();
  static final AppData sharedInstance = AppData._();
  var currentUserdata = Users();
  String currentUserId = "";
  List<Users> users = [];
  List<Channels> userChannel = [];
  List<OppositeUser> userOppsiteChannelList = [];
  var stateProvider = new StateProvider();

  void startListner() {
    Firestore.instance
        .collection(pCollectionUsers)
        .snapshots(includeMetadataChanges: true)
        .listen(currentUserData);

    Firestore.instance
        .collection(pCollectionChannels)
        .where(pchannelUsers, arrayContainsAny: [currentUserId])
        .snapshots(includeMetadataChanges: true)
        .listen(currentChannelData);
  }

  void currentUserData(QuerySnapshot event) {
    var documentsdata = event.documents;
    List<Users> usersList = [];
    for (var items in documentsdata) {
      usersList.add(Users.fromJson(items.data, items.documentID));
    }

    var udata = usersList.where((element) => element.uid == currentUserId);
    AppData.sharedInstance.currentUserdata = udata.first;
    AppData.sharedInstance.currentUserId = currentUserId;
    usersList.removeWhere((element) => element.uid == currentUserId);
    AppData.sharedInstance.users = usersList;

    stateProvider.notify(ObserverState.USER_LIST);
  }

  void currentChannelData(QuerySnapshot event) {
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
        userOppsiteChannelList.add(OppositeUser(id: data.first.uid,channelId: cData.id));
      }
    }

    AppData.sharedInstance.userChannel = usersChannelList;
    stateProvider.notify(ObserverState.CHANNEL_LIST);
  }
}
