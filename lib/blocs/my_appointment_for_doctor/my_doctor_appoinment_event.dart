abstract class MyAppointmentDoctorEvent {}

class FetchMyAppoinmentDoctorEvent extends MyAppointmentDoctorEvent {}

class AcceptAppointmentButtonPressed extends MyAppointmentDoctorEvent {
  int index;
  String status;
  AcceptAppointmentButtonPressed({required this.index, required this.status});
}

class RejectAppointmentButtonPressed extends MyAppointmentDoctorEvent {
  int index;
  String status;
  RejectAppointmentButtonPressed({required this.index, required this.status});
}

class GetPateintData extends MyAppointmentDoctorEvent {
  final String? patientUid;
  GetPateintData({required this.patientUid});
}
