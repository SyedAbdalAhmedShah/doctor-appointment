import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/my_appointment_for_doctor/my_doctor_appoinment_event.dart';
import 'package:medicine_notifier/blocs/my_appointment_for_doctor/my_doctor_appoinment_state.dart';
import 'package:medicine_notifier/blocs/my_appointment_for_doctor/my_doctor_appointment_bloc.dart';
import 'package:medicine_notifier/model/my_appoinment_model.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/components/doctor_manager.dart';
import 'package:medicine_notifier/view/components/strings.dart';

class DoctorHomeScreen extends StatefulWidget {
  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  MyAppoitmentDoctorBloc _bloc = MyAppoitmentDoctorBloc();
  List<MyAppoinments> appointments = [];
  ScrollController _scrollController = ScrollController();

  Stream<List<MyAppoinments>>? stream;
  @override
  void initState() {
    ApiHelper().getAppointmentForSpecificDoctor(DoctorManager.doctor.uid!);
    _bloc.add(FetchMyAppoinmentDoctorEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: BlocListener(
      bloc: _bloc,
      listener: (context, state) {
        print("state is $state ");
        if (state is MyAppointmentDoctorLoadingState) {
          Center(
            child: Stack(
              children: [
                CircularProgressIndicator(
                  color: kDoctorPrimaryColor,
                ),
              ],
            ),
          );
        }
        if (state is MyAppointmentDoctorSuccessfullState) {
          stream = state.appointmentsStream;

          print('stream isss $stream');
        }
      },
      child: BlocBuilder(
        bloc: _bloc,
        builder: (BuildContext context, state) {
          return _buildBody(size);
        },
      ),
    ));
  }

  _buildBody(
    Size size,
  ) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<List<MyAppoinments>> snapshot) {
          final appointments = snapshot.data;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            print('done');
          }
          if (snapshot.hasError)
            return Center(child: new Text('Error: ${snapshot.error}'));
          return Column(children: [
            Expanded(
              child: CupertinoScrollbar(
                controller: _scrollController,
                child: ListView.separated(
                  controller: _scrollController,
                  separatorBuilder: (context, index) => SizedBox(
                    height: size.height * 0.02,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                      // margin: EdgeInsets.all(15),
                      padding: EdgeInsets.all(8),
                      height: size.height * 0.24,
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kDoctorPrimaryColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: size.width * 0.05,
                                foregroundImage:
                                    AssetImage('assets/no_picture.png'),
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                "${appointments![index].pateintName}",
                                style: TextStyle(
                                    color: kDoctorPrimaryColor, fontSize: 17),
                              )
                            ],
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          Text(
                            '${appointments[index].disease!}',
                            style: TextStyle(
                                color: kDoctorPrimaryColor, fontSize: 17),
                          ),
                          Text(
                            '${appointments[index].description!}',
                            style: TextStyle(
                                color: kDoctorPrimaryColor, fontSize: 17),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${appointments[index].time!}',
                                    style: TextStyle(
                                        color: kDoctorPrimaryColor,
                                        fontSize: 17),
                                  ),
                                  Text(
                                    ' ${appointments[index].date}',
                                    style: TextStyle(
                                        color: kDoctorPrimaryColor,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          appointments[index].status == FirebaseStrings.accepted
                              ? Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    FirebaseStrings.accepted,
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: kDoctorPrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                              color: Colors.grey.shade500,
                                              offset: Offset(0, 1))
                                        ]),
                                  ),
                                )
                              : appointments[index].status ==
                                      FirebaseStrings.rejected
                                  ? _rejectedText()
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: () {
                                              _bloc.add(
                                                  RejectAppointmentButtonPressed(
                                                      index: index,
                                                      status: FirebaseStrings
                                                          .rejected));
                                            },
                                            child: _rejectButton()),
                                        SizedBox(
                                          width: size.width * 0.01,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              print(index);
                                              _bloc.add(
                                                  AcceptAppointmentButtonPressed(
                                                      index: index,
                                                      status: FirebaseStrings
                                                          .accepted));
                                              // _acceptance(index);
                                            },
                                            child: _acceptButton())
                                      ],
                                    )
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data != null && snapshot.data!.length > 0
                      ? snapshot.data!.length
                      : 0,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.08,
            )
          ]);
        });
  }

  Align _rejectedText() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Text(FirebaseStrings.rejected,
          style: TextStyle(
              fontSize: 20,
              color: Colors.red,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: Colors.grey.shade500, offset: Offset(0, 1))
              ])),
    );
  }

  _acceptance(
    int index,
  ) {
    // _bloc.add(AcceptOrRejectTheAppointment(index: index, status: 'accepted'));
    ApiHelper().updateTheAppointmentStatus(
        uid: DoctorManager.doctor.uid!,
        index: index,
        statusResponse: 'Accepted');
  }

  Container _rejectButton() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: kDoctorPrimaryColor, borderRadius: BorderRadius.circular(5)),
      child: Text('reject',
          style: TextStyle(
            color: Colors.red,
          )),
    );
  }

  Container _acceptButton() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: kDoctorPrimaryColor, borderRadius: BorderRadius.circular(5)),
      child: Text('Accept',
          style: TextStyle(
            color: kTextColor,
          )),
    );
  }

  Future<List<QueryDocumentSnapshot<Object?>>> getMyAppoinment(
      AsyncSnapshot<QuerySnapshot<Object?>> snapshot) async {
    final myAppoinments = await snapshot.data!.docs
        .where(
            (element) => element.get('doctorUid') == DoctorManager.doctor.uid)
        .toList();

    return myAppoinments;
  }
}
