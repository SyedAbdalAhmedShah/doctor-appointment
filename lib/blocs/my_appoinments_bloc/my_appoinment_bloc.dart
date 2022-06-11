import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/my_appoinments_bloc/my_appoinment_event.dart';
import 'package:medicine_notifier/blocs/my_appoinments_bloc/my_appoinment_state.dart';
import 'package:medicine_notifier/model/my_appoinment_model.dart';

class MyAppoinmentBloc extends Bloc<MyAppoinmentEvent, MyAppoinmentState> {
  ApiHelper api = ApiHelper();

  MyAppoinmentBloc() : super(MyAppoinmentInitialState()) {
    on<FetchedMyAppoinmentEvent>((event, emit) async {
      emit(MyAppoinmentLoadingState());
      try {
        List<MyAppoinments> appoinments = await api.getMyAppoinments();

        emit(MyAppoinmentFetchedState(myAppoinments: appoinments));
      } catch (error) {
        emit(MyAppoinmentFailureState(error: error.toString()));
      }
    });
  }
}
