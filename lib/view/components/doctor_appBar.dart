import 'package:flutter/material.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';

class DoctorAppbar extends StatelessWidget {
  final String title;
  const DoctorAppbar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
        Colors.teal.shade300,
        kDoctorPrimaryColor,
      ]))),
      centerTitle: true,
      title: Text(title),
    );
  }
}
