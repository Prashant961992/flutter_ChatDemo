
class Messages {
  String messageId;
  String from;
  String userFirebaseId;
  String date;
  MessagesMeta meta;
  List<String> to;
  int type;

  Messages(
      {this.messageId,
      this.from,
      this.userFirebaseId,
      this.date,
      this.meta,
      this.to,
      this.type});

  Messages.fromJson(Map<String, dynamic> json) {
    messageId = json['messageId'];
    from = json['from'];
    userFirebaseId = json['user-firebase-id'];
    date = json['date'];
    meta = json['meta'] != null ? new MessagesMeta.fromJson(json['meta']) : null;
    to = json['to'].cast<String>();
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['messageId'] = this.messageId;
    data['from'] = this.from;
    data['user-firebase-id'] = this.userFirebaseId;
    data['date'] = this.date;
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['to'] = this.to;
    data['type'] = this.type;
    return data;
  }
}

class MessagesMeta {
  String text;
  String imageUrl;
  String videoUrl;

  MessagesMeta({this.text, this.imageUrl, this.videoUrl});

  MessagesMeta.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['imageUrl'] = this.imageUrl;
    data['videoUrl'] = this.videoUrl;
    return data;
  }
}