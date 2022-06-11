import 'package:medicine_notifier/model/my_appoinment_model.dart';
import 'package:medicine_notifier/model/patient_model.dart';

abstract class MyAppointmentDoctorState {}

class MyAppointmentDoctorInitialState extends MyAppointmentDoctorState {}

class MyAppointmentDoctorLoadingState extends MyAppointmentDoctorState {}

class AppointmentStatusUpdatedsState extends MyAppointmentDoctorState {}

class MyAppointmentDoctorSuccessfullState extends MyAppointmentDoctorState {
  Stream<List<MyAppoinments>> appointmentsStream;
  MyAppointmentDoctorSuccessfullState({required this.appointmentsStream});
}

class MyAppointmentDoctorFailureState extends MyAppointmentDoctorState {
  String message;
  MyAppointmentDoctorFailureState({required this.message});
}

class GetPatientAllDataState extends MyAppointmentDoctorState {
  final PatientModel patients;
  GetPatientAllDataState({required this.patients});
}
