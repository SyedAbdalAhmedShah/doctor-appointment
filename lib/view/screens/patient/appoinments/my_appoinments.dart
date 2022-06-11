import 'dart:ui';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/blocs/my_appoinments_bloc/my_appoinment_bloc.dart';
import 'package:medicine_notifier/blocs/my_appoinments_bloc/my_appoinment_event.dart';
import 'package:medicine_notifier/blocs/my_appoinments_bloc/my_appoinment_state.dart';
import 'package:medicine_notifier/model/my_appoinment_model.dart';
import 'package:medicine_notifier/sizer.dart';
import 'package:medicine_notifier/view/components/alert_box.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/page_animation/custom_page_route.dart';
import 'package:medicine_notifier/view/screens/patient/appoinments/appoinment_detail.dart';
import 'package:medicine_notifier/view/screens/patient/nav_bar_screens/nav_bar_all_screens.dart';

class MyAppointmentsScreen extends StatefulWidget {
  @override
  State<MyAppointmentsScreen> createState() => _MyAppointmentsScreenState();
}

class _MyAppointmentsScreenState extends State<MyAppointmentsScreen> {
  MyAppoinmentBloc _bloc = MyAppoinmentBloc();

  List<Color> colors = [Colors.teal, Colors.indigo, Colors.blue];
  List<MyAppoinments> appoinments = [];

  @override
  void initState() {
    _bloc.add(FetchedMyAppoinmentEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('My Appoinments'),
        ),
        body: BlocConsumer(
            bloc: _bloc,
            builder: (context, state) {
              if (state is MyAppoinmentLoadingState) {
                Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state is MyAppoinmentFetchedState) {
                appoinments = state.myAppoinments;

                return _builBody();
              }
              if (state is MyAppoinmentFailureState) {
                return Alert.dialogBox(
                    errormessage: state.error, context: context);
              }
              return Center(child: CupertinoActivityIndicator());
            },
            listener: (context, state) {
              print("state is $state");
            }));
  }

  Column _builBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: appoinments.isEmpty ? _noAppoinment() : _appoinmentList(),
        )
      ],
    );
  }

  ListView _appoinmentList() {
    return ListView.builder(
      itemCount: appoinments.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Dismissible(
          background: Container(
            color: Colors.red,
          ),
          key: GlobalKey(),
          child: _buildAppoinmentCard(context, index),
        ),
      ),
    );
  }

  ExpansionTile _buildAppoinmentCard(BuildContext context, int index) {
    return ExpansionTile(
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      backgroundColor: Colors.white54,
      collapsedBackgroundColor: Colors.white,
      collapsedIconColor: kTextColor,
      iconColor: kTextColor,
      leading: CircleAvatar(
        radius: 30,
        foregroundImage: AssetImage(
          'assets/appointmenttt.png',
        ),
      ),
      title: Column(
        children: [
          Text(
            'Your Appoinment On',
            style: TextStyle(
                color: kPrimaryColor,
                fontSize: 17,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: size.convert(context, 12),
          ),
          Text(
            '${appoinments[index].date}',
            style: TextStyle(color: kTextColor),
          ),
        ],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                'Disase: ',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                    fontSize: 17),
              ),
              Text(
                '${appoinments[index].disease}',
                style: TextStyle(color: kTextColor, fontSize: 17),
              ),
            ],
          ),
        ),
        InkWell(
            onTap: () {
              Navigator.of(context).push(CustomPageRoute(
                  child: AppoinmentDetail(
                appointments: appoinments[index],
              )));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Detail',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: kPrimaryColor),
                  ),
                ),
              ],
            )),
      ],
    );
  }

  Center _noAppoinment() {
    return Center(
      child: Text(
        'You dont have any appoinment',
        style: TextStyle(color: kTextColor),
      ),
    );
  }
}
