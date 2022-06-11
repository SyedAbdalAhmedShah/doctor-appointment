import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  String? doctorName;
  Timestamp? date;
  String? conversationID;
  String? doctorUid;
  String? userId;

  Conversation(
      {this.doctorName,
      this.date,
      this.conversationID,
      this.doctorUid,
      this.userId});

  Conversation.fromJson(Map<String, dynamic> json) {
    doctorName = json['DoctorName'];
    date = json['date'];
    conversationID = json['ConversationID'];
    doctorUid = json['doctorUid'];
    userId = json['userId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['DoctorName'] = this.doctorName;
    data['date'] = this.date;
    data['ConversationID'] = this.conversationID;
    data['doctorUid'] = this.doctorUid;
    data['userId'] = this.userId;
    return data;
  }
}
