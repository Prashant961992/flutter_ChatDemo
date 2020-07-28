
class Users {
  UsersMeta meta;
  bool online;
  String displayName;
  String uid;

  Users({this.meta, this.online, this.displayName});

  Users.fromJson(Map<String, dynamic> json,String id) {
    meta = json['meta'] != null ? new UsersMeta.fromJson(json['meta']) : null;
    online = json['online'];
    displayName = json['displayName'];
    uid = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['online'] = this.online;
    data['displayName'] = this.displayName;
    data['uid'] = this.uid;
    return data;
  }
}

class UsersMeta {
  String phone;
  String locality;
  String availability;
  String status;
  String email;
  String nameLowercase;
  // String createdAt;
  String photoUrl;
  String name;

  UsersMeta(
      {this.phone,
      this.locality,
      this.availability,
      this.status,
      this.email,
      this.nameLowercase,
      // this.createdAt,
      this.photoUrl,
      this.name});

  UsersMeta.fromJson(Map<String, dynamic> json) {
    phone = json['phone'];
    locality = json['locality'];
    availability = json['availability'];
    status = json['status'];
    email = json['email'];
    nameLowercase = json['name-lowercase'];
    // createdAt = json['createdAt'];
    photoUrl = json['photoUrl'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phone'] = this.phone;
    data['locality'] = this.locality;
    data['availability'] = this.availability;
    data['status'] = this.status;
    data['email'] = this.email;
    data['name-lowercase'] = this.nameLowercase;
    // data['createdAt'] = this.createdAt;
    data['photoUrl'] = this.photoUrl;
    data['name'] = this.name;
    return data;
  }
}