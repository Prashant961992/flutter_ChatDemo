class OppositeUser {
  String id;
  String channelId;

  OppositeUser({this.id,this.channelId});

  OppositeUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channelId = json['channelId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['channelId'] = this.channelId;
    return data;
  }
}