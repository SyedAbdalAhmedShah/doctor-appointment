abstract class DoctorDetailEvent {}

class FetchDoctorDetailEvent extends DoctorDetailEvent {
  String uid;
  FetchDoctorDetailEvent({required this.uid});
}
