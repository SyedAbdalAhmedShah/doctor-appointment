import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/my_appointment_for_doctor/my_doctor_appoinment_event.dart';
import 'package:medicine_notifier/blocs/my_appointment_for_doctor/my_doctor_appoinment_state.dart';
import 'package:medicine_notifier/model/my_appoinment_model.dart';
import 'package:medicine_notifier/model/patient_model.dart';
import 'package:medicine_notifier/view/components/doctor_manager.dart';

class MyAppoitmentDoctorBloc
    extends Bloc<MyAppointmentDoctorEvent, MyAppointmentDoctorState> {
  ApiHelper repo = ApiHelper();
  MyAppoitmentDoctorBloc() : super(MyAppointmentDoctorInitialState()) {
    on<FetchMyAppoinmentDoctorEvent>((event, emit) async {
      emit(MyAppointmentDoctorLoadingState());
      try {
        Stream<List<MyAppoinments>> appointments = await repo
            .getAppointmentForSpecificDoctor(DoctorManager.doctor.uid!);

        emit(MyAppointmentDoctorSuccessfullState(
            appointmentsStream: appointments));
      } catch (error) {
        emit(MyAppointmentDoctorFailureState(message: error.toString()));
      }
    });

    on<AcceptAppointmentButtonPressed>((event, emit) async {
      emit(MyAppointmentDoctorLoadingState());
      try {
        await repo.updateTheAppointmentStatus(
            uid: DoctorManager.doctor.uid!,
            index: event.index,
            statusResponse: event.status);
        emit(AppointmentStatusUpdatedsState());
      } catch (error) {
        print('excetion : ${error.toString()}');
        emit(MyAppointmentDoctorFailureState(message: error.toString()));
      }
    });
    on<RejectAppointmentButtonPressed>((event, emit) async {
      emit(MyAppointmentDoctorLoadingState());
      try {
        await repo.updateTheAppointmentStatus(
            uid: DoctorManager.doctor.uid!,
            index: event.index,
            statusResponse: event.status);
        emit(AppointmentStatusUpdatedsState());
      } catch (error) {
        print('excetion : ${error.toString()}');
        emit(MyAppointmentDoctorFailureState(message: error.toString()));
      }
    });
    on<GetPateintData>((event, emit) async {
      emit(MyAppointmentDoctorLoadingState());
      try {
        final patientData = await repo.getPatientAfterLogin(event.patientUid!);
        final parsedPatient = pateitnParsedIntoModel(patientData);
        emit(GetPatientAllDataState(patients: parsedPatient));
      } catch (error) {
        print('error occured ' + error.toString());
        emit(MyAppointmentDoctorFailureState(message: error.toString()));
      }
    });
  }

  PatientModel pateitnParsedIntoModel(
      DocumentSnapshot<Map<String, dynamic>> patient) {
    final parsedPatient = PatientModel.fromJson(patient.data()!);
    print('patinet name is: ' + parsedPatient.patientName!);
    return parsedPatient;
  }
}
