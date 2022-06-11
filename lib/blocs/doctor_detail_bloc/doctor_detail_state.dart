import 'package:medicine_notifier/model/doctor_model.dart';

abstract class DoctorDetailState {}

class InitialDoctorDetailState extends DoctorDetailState {}

class LoadingDoctorDetial extends DoctorDetailState {}

class SuccessFullyDoctorDetailState extends DoctorDetailState {
  DoctorModel doctor;
  SuccessFullyDoctorDetailState({required this.doctor});
}

class FailureDoctorDetailState extends DoctorDetailState {
  String error;
  FailureDoctorDetailState({required this.error});
}
