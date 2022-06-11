import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/doctor_detail_bloc/doctor_detail_event.dart';

import 'doctor_detail_state.dart';

class DoctorDetailBloc extends Bloc<DoctorDetailEvent, DoctorDetailState> {
  ApiHelper api = ApiHelper();
  DoctorDetailBloc() : super(InitialDoctorDetailState()) {
    on<FetchDoctorDetailEvent>((event, emit) async {
      emit(LoadingDoctorDetial());
      try {
        final doctor = await api.getDoctorDetails(event.uid);

        emit(SuccessFullyDoctorDetailState(doctor: doctor.first));
      } catch (error) {
        FailureDoctorDetailState(error: error.toString());
      }
    });
  }
}
