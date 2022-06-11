import 'package:medicine_notifier/model/doctor_model.dart';

class DoctorManager {
  DoctorManager._privateConstructor();

  static DoctorModel doctor = DoctorModel();
  static late bool isDoctorLogedIn;
  static final DoctorManager _instance = DoctorManager._privateConstructor();

  factory DoctorManager() {
    return _instance;
  }
}
