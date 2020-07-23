class Channels {
  String id;
  ChannelsMeta meta;
  List<Isread> isread;
  List<String> users;
  List<UsersInfo> usersInfo;

  Channels({this.id, this.meta, this.isread, this.users, this.usersInfo});

  Channels.fromJson(Map<String, dynamic> json,String uid) {
    id = uid;
    meta = json['meta'] != null ? new ChannelsMeta.fromJson(json['meta']) : null;
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