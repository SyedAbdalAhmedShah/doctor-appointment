import 'package:medicine_notifier/model/my_appoinment_model.dart';

abstract class MyAppoinmentState {}

class MyAppoinmentInitialState extends MyAppoinmentState {}

class MyAppoinmentLoadingState extends MyAppoinmentState {}

class MyAppoinmentFetchedState extends MyAppoinmentState {
  List<MyAppoinments> myAppoinments;
  MyAppoinmentFetchedState({required this.myAppoinments});
}

class MyAppoinmentFailureState extends MyAppoinmentState {
  String error;
  MyAppoinmentFailureState({required this.error});
}
