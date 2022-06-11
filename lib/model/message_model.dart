import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String? messageId;
  String? description;
  Timestamp? dateTime;
  String? userName;
  String? userId;
  String? targetUserId;

  Messages(
      {this.userId,
      this.targetUserId,
      this.userName,
      this.messageId,
      this.dateTime,
      this.description});

  factory Messages.formJson(Map<String, dynamic> json) => Messages(
      messageId: json['messageId'],
      dateTime: json['dateTime'],
      userName: json['userName'],
      description: json['description'],
      targetUserId: json['doctorId'],
      userId: json['patientId']);

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'description': description,
        'userName': userName,
        'dateTime': dateTime,
        'patientId': userId,
        'doctorId': targetUserId
      };
}
