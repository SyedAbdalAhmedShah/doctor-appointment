// To parse this JSON data, do
//
//     final MyAppoinments = MyAppoinmentsFromJson(jsonString);

import 'dart:convert';

MyAppoinments MyAppoinmentsFromJson(String str) =>
    MyAppoinments.fromJson(json.decode(str));

String MyAppoinmentsToJson(MyAppoinments data) => json.encode(data.toJson());

class MyAppoinments {
  MyAppoinments({
    this.date,
    this.disease,
    this.patientUid,
    this.description,
    this.time,
    this.doctorUid,
    this.pateintName,
    this.pateintAge,
    this.status,
  });

  String? date;
  String? disease;
  String? patientUid;
  String? description;
  String? time;
  String? doctorUid;
  String? pateintName;
  String? status;
  String? pateintAge;

  factory MyAppoinments.fromJson(Map<String, dynamic> json) => MyAppoinments(
        date: json["date"],
        disease: json["disease"],
        patientUid: json["patientUid"],
        description: json["description"],
        time: json["time"],
        status: json['Status'],
        doctorUid: json["doctorUid"],
        pateintName: json["pateintName"],
        pateintAge: json["pateintAge"],
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "disease": disease,
        "patientUid": patientUid,
        "description": description,
        "time": time,
        'Status': status,
        "doctorUid": doctorUid,
        "pateintName": pateintName,
        "pateintAge": pateintAge,
      };
}
