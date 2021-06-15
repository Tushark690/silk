
class ChatModel{
  String rec;
  String message;
  var messageTime;
  String roomId;
  String status;

  ChatModel({
    this.rec,
    this.message,
    this.messageTime,
    this.roomId,
    this.status
  });

  ChatModel.fromJson(Map<String, dynamic> json) {
    rec = json['rec'];
    message = json['message'];
    messageTime=json['messageTime'];
    roomId=json['roomId'];
    status=json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rec'] = this.rec;
    data['message'] = this.message;
    data['messageTime'] = this.messageTime;
    data['roomId'] = this.roomId;
    data['status'] = this.status;
    return data;
  }

}