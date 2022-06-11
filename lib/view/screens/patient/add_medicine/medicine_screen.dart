import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:medicine_notifier/controller/add_medicine_controller.dart';
import 'package:medicine_notifier/model/add_medicine.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/components/custom_drawer.dart';

import 'package:medicine_notifier/view/page_animation/custom_page_route.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:sizer/sizer.dart';

import 'add_medicine_sceen.dart';

class MedicineScreen extends StatefulWidget {
  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final controller = Get.put(MedicineController());

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
            onRefresh: () {
              //refresh The List of the medicines
              return Future(() => controller.getAllRecord());
            },
            child: Obx(
              () => controller.medicines.isEmpty
                  ? Center(child: Text('No Medicine is Added'))
                  : ListView.builder(
                      itemCount: controller.medicines.length,
                      itemBuilder: (ctx, index) => Container(
                            padding: EdgeInsets.all(10.sp),
                            height: 15.h,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.white24,
                                      offset: Offset(0, 2),
                                      blurRadius: 1)
                                ],
                                border: Border.all(color: Colors.white38),
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(4.sp)),
                            margin: EdgeInsets.all(10.sp),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Tablet Name : ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      controller.medicines[index].tabletName!,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Tablet Left : ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(controller
                                        .medicines[index].totalTablet!
                                        .toString()),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Time : ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${controller.medicines[index].time}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
            )),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: kPrimaryColor,
            onPressed: () {
              print('add medicine button');

              showModalBottomSheet(
                context: context,
                shape:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
                isScrollControlled: true,
                builder: (context) => AddMedicinePage(),

                //  DraggableScrollableSheet(
                //       builder: (_, cont) => Container(
                //         color: Colors.white,
                //       ),
                //     )
              );
            },
            icon: Icon(
              Icons.medical_services_outlined,
              color: Colors.white70,
            ),
            label: Text(
              'Add Medicine',
              style:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}
