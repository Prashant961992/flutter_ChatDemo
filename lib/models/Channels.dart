import 'package:cloud_firestore/cloud_firestore.dart';

class Channels {
  String id;
  ChannelsMeta meta;
  LastMessage lastmessage;
  List<Isread> isread;
  List<String> users;
  List<UsersInfo> usersInfo;

  Channels({this.id, this.meta, this.isread,this.lastmessage,this.users, this.usersInfo});

  Channels.fromJson(Map<String, dynamic> json,String uid) {
    id = uid;
    meta = json['meta'] != null ? new ChannelsMeta.fromJson(json['meta']) : null;
    lastmessage = json['lastMessage'] != null ? new LastMessage.fromJson(json['lastMessage']) : null;
    if (json['isread'] != null) {
      isread = new List<Isread>();
      json['isread'].forEach((v) {
        isread.add(new Isread.fromJson(v));
      });
    }
    users = json['users'].cast<String>();
    if (json['usersInfo'] != null) {
      usersInfo = new List<UsersInfo>();
      json['usersInfo'].forEach((v) {
        usersInfo.add(new UsersInfo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    // if (this.lastmessage != null) {
    //   data['lastMessage'] = this.lastmessage.toJson();
    // }
    if (this.isread != null) {
      data['isread'] = this.isread.map((v) => v.toJson()).toList();
    }
    data['users'] = this.users;
    if (this.usersInfo != null) {
      data['usersInfo'] = this.usersInfo.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChannelsMeta {
  String creationDate;
  String creator;
  String creatorEntityId;
  String name;
  int type;

  ChannelsMeta(
      {this.creationDate,
      this.creator,
      this.creatorEntityId,
      this.name,
      this.type});

  ChannelsMeta.fromJson(Map<String, dynamic> json) {
    creationDate = json['creation-date'];
    creator = json['creator'];
    creatorEntityId = json['creator-entity-id'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creation-date'] = this.creationDate;
    data['creator'] = this.creator;
    data['creator-entity-id'] = this.creatorEntityId;
    data['name'] = this.name;
    data['type'] = this.type;
    return data;
  }
}

class Isread {
  bool id;
  String status;

  Isread({this.id, this.status});

  Isread.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}

class UsersInfo {
  String uid;
  String status;

  UsersInfo({this.uid, this.status});

  UsersInfo.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['status'] = this.status;
    return data;
  }
}

class LastMessage {
  DateTime date;
  String from;
  LastMessageMeta lastMessahemeta;
  String type;
  String userFirebaseId;

  LastMessage(
      {this.date, this.from, this.lastMessahemeta, this.type, this.userFirebaseId});

  LastMessage.fromJson(Map<String, dynamic> json) {
    date = (json['date'] as Timestamp).toDate();
    from = json['from'];
    lastMessahemeta = json['meta'] != null ? new LastMessageMeta.fromJson(json['meta']) : null;
    type = json['type'];
    userFirebaseId = json['user-firebase-id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['from'] = this.from;
    if (this.lastMessahemeta != null) {
      data['meta'] = this.lastMessahemeta.toJson();
    }
    data['type'] = this.type;
    data['user-firebase-id'] = this.userFirebaseId;
    return data;
  }
}

class LastMessageMeta {
  String text;
  // String imageUrl;
  // String videoUrl;
  // String fileurl;
  // String audioUrl;
  // 
  LastMessageMeta({this.text});
  // LastMessageMeta({this.text, this.imageUrl, this.videoUrl, this.fileurl, this.audioUrl});

  LastMessageMeta.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    // imageUrl = json['imageUrl'];
    // videoUrl = json['videoUrl'];
    // fileurl = json['fileurl'];
    // audioUrl = json['audioUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    // data['imageUrl'] = this.imageUrl;
    // data['videoUrl'] = this.videoUrl;
    // data['fileurl'] = this.fileurl;
    // data['audioUrl'] = this.audioUrl;
    return data;
  }
}