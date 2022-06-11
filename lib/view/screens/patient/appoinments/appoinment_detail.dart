import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/doctor_detail_bloc/doctor_detail_bloc.dart';
import 'package:medicine_notifier/blocs/doctor_detail_bloc/doctor_detail_event.dart';
import 'package:medicine_notifier/blocs/doctor_detail_bloc/doctor_detail_state.dart';
import 'package:medicine_notifier/model/doctor_model.dart';
import 'package:medicine_notifier/model/my_appoinment_model.dart' as model;
import 'package:medicine_notifier/sizer.dart';
import 'package:medicine_notifier/view/components/alert_box.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/components/strings.dart';
import 'package:medicine_notifier/view/components/user_manager.dart';
import 'package:medicine_notifier/view/page_animation/custom_page_route.dart';
import 'package:medicine_notifier/view/screens/chat/Chat_screen.dart';

class AppoinmentDetail extends StatefulWidget {
  model.MyAppoinments? appointments;
  AppoinmentDetail({required this.appointments});

  @override
  State<AppoinmentDetail> createState() => _AppoinmentDetailState();
}

class _AppoinmentDetailState extends State<AppoinmentDetail> {
  DoctorDetailBloc _bloc = DoctorDetailBloc();
  DoctorModel? doctor;
  double initialchild = 0.5;
  double minChildSize = 0.5;

  @override
  void initState() {
    _bloc
        .add(FetchDoctorDetailEvent(uid: widget.appointments!.doctorUid ?? ''));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Text(widget.appointments!.doctorUid!);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Your Appointment Detail'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(CustomPageRoute(
                      child: ChatScreen(
                    senderName: doctor!.doctorName!,
                    senderID: doctor!.uid!,
                    conversationID: '',
                  )));
                },
                icon: Icon(Icons.chat))
          ],
        ),
        body: BlocConsumer(
            bloc: _bloc,
            builder: (context, state) {
              if (state is LoadingDoctorDetial) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state is SuccessFullyDoctorDetailState) {
                doctor = state.doctor;
                return _buildBody(size);
              }
              if (state is FailureDoctorDetailState) {
                return Alert.dialogBox(
                    errormessage: state.error, context: context);
              }
              return Center(
                child: CupertinoActivityIndicator(),
              );
            },
            listener: (context, state) {}));
  }

  Stack _buildBody(
    Size size,
  ) {
    return Stack(
      children: [
        Image.asset(
          'assets/no_profile-pic.jpg',
          fit: BoxFit.cover,
        ),
        _dragableScrollableSheet(size),
      ],
    );
  }

  DraggableScrollableSheet _dragableScrollableSheet(Size size) {
    return DraggableScrollableSheet(
        initialChildSize: initialchild,
        minChildSize: minChildSize,
        maxChildSize: 1,
        builder: (context, controller) => Container(
              decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: IntrinsicHeight(
                  child: ListView(
                    controller: controller,
                    children: [
                      _scroller(),
                      verticalGap(
                        size,
                        0.02,
                      ),
                      _buildHeading('Doctor Detail '),
                      verticalGap(
                        size,
                        0.02,
                      ),
                      _buildData(
                          title: 'Doctor Name: ',
                          name: '${doctor!.doctorName}'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(size, 0.01),
                      _buildData(
                          title: 'Doctor Speciality: ',
                          name: '${doctor!.speciality}'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(size, 0.01),
                      _buildData(
                          title: 'Doctor Fee: ', name: '${doctor!.fee},'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(size, 0.01),
                      _buildData(
                          title: 'Clinic Name: ',
                          name: '${doctor!.clinicName}'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(
                        size,
                        0.02,
                      ),
                      _buildHeading('Your Appoinment Detail '),
                      verticalGap(size, 0.01),
                      verticalGap(size, 0.01),
                      verticalGap(size, 0.01),
                      _buildData(
                          title: 'Your Name : ',
                          name: '${UserManager.user.patientName} '),
                      verticalGap(size, 0.01),
                      _divider(),
                      _buildData(
                          title: 'Disease Name: ',
                          name: '${widget.appointments!.disease}'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(size, 0.01),
                      _buildData(
                          title: 'Description : ',
                          name: '${widget.appointments!.description}'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(size, 0.01),
                      _buildData(
                          title: 'Appoinment Time : ',
                          name: '${widget.appointments!.time}'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(size, 0.01),
                      _buildData(
                          title: 'Appoinment Date : ',
                          name: '${widget.appointments!.date}'),
                      verticalGap(size, 0.01),
                      _divider(),
                      verticalGap(size, 0.05),
                      widget.appointments!.status == FirebaseStrings.accepted
                          ? appointmentStatus(
                              status: FirebaseStrings.accepted,
                              color: kDoctorPrimaryColor)
                          : widget.appointments!.status ==
                                  FirebaseStrings.rejected
                              ? appointmentStatus(
                                  status: FirebaseStrings.rejected,
                                  color: Colors.red)
                              : appointmentStatus(
                                  status: FirebaseStrings.pending,
                                  color: Colors.amber.shade800)
                    ],
                  ),
                ),
              ),
            ));
  }

  Align appointmentStatus({required String status, required Color color}) {
    return Align(
        alignment: Alignment.center,
        child: Text(
          status,
          style: TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: color),
        ));
  }

  Text _buildHeading(String headingName) {
    return Text(
      headingName,
      style: TextStyle(
          fontSize: 20, fontWeight: FontWeight.bold, color: kTextColor),
    );
  }

  Row _buildData({required String title, required String name}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 17, color: kPrimaryColor, fontWeight: FontWeight.w600),
        ),
        Flexible(
          child: Text(
            name,
            maxLines: 2,
            overflow: TextOverflow.clip,
            style: TextStyle(
                overflow: TextOverflow.clip,
                fontSize: 17,
                color: kTextColor,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Divider _divider() {
    return Divider(
      color: Colors.black45,
      height: 2,
    );
  }

  SizedBox verticalGap(Size size, double gap) {
    return SizedBox(height: size.height * gap);
  }

  Row _scroller() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: 12,
            width: 100,
            decoration: BoxDecoration(
                color: kTextColor, borderRadius: BorderRadius.circular(20))),
      ],
    );
  }
}
