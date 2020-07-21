
class UserChannels {
  String invitedBy;
  String channelId;

  UserChannels({this.invitedBy, this.channelId});

  UserChannels.fromJson(Map<String, dynamic> json,String id) {
    invitedBy = json['invitedBy'];
    channelId = id;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['invitedBy'] = this.invitedBy;
    data['channelId'] = this.channelId;
    return data;
  }
}