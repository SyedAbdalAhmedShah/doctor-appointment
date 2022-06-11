// To parse this JSON data, do
//
//     final doctorModel = doctorModelFromJson(jsonString);

import 'dart:convert';

DoctorModel doctorModelFromJson(String str) =>
    DoctorModel.fromJson(json.decode(str));

String doctorModelToJson(DoctorModel data) => json.encode(data.toJson());

class DoctorModel {
  DoctorModel(
      {this.clinicName,
      this.uid,
      this.speciality,
      this.doctorName,
      this.email,
      this.fee,
      this.phoneNumber,
      this.timing,
      this.proilePicture});

  String? clinicName;
  String? uid;
  String? speciality;
  String? doctorName;
  String? email;
  String? fee;
  String? timing;
  String? phoneNumber;
  String? proilePicture;

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
      clinicName: json["clinicName"],
      uid: json["uid"],
      speciality: json["speciality"],
      doctorName: json["doctorName"],
      email: json["email"],
      fee: json['fee'],
      phoneNumber: json['phoneNumber'],
      timing: json['timing'],
      proilePicture: json['profilePicture']);

  Map<String, dynamic> toJson() => {
        "clinicName": clinicName,
        "uid": uid,
        "speciality": speciality,
        "doctorName": doctorName,
        "email": email,
        "fee": fee,
        "timing": timing,
        "phoneNumber": phoneNumber,
        "profilePicture": proilePicture
      };
}
