import 'package:flutter/material.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/components/doctor_appBar.dart';
import 'package:medicine_notifier/view/components/doctor_manager.dart';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: size.height * 0.35,
              child: Stack(
                children: [
                  Container(
                      height: size.height * 0.2,
                      width: size.width,
                      decoration: BoxDecoration(color: kDoctorPrimaryColor)),
                  Positioned(
                    top: size.height * 0.1,
                    child: Container(
                      height: size.height * 0.23,
                      width: size.width,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 10,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                            image: AssetImage('assets/no_profile-pic.jpg'),
                            fit: BoxFit.fitHeight),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text('${DoctorManager.doctor.doctorName}',
                  style: TextStyle(
                      fontSize: 30,
                      color: Colors.teal.shade700,
                      fontWeight: FontWeight.bold)),
            ),
            _verticalGap(size),
            _infromation(title: '${DoctorManager.doctor.speciality}'),
            _verticalGap(size),
            _infromation(title: '${DoctorManager.doctor.clinicName}'),
            _verticalGap(size),
            _infromation(title: '${DoctorManager.doctor.email}'),
            _verticalGap(size),
          ],
        ),
      ),
    );
  }

  Padding _infromation({required String title}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Text(title,
          style: TextStyle(
            fontSize: 26,
            color: kTextColor,
          )),
    );
  }

  SizedBox _verticalGap(Size size) {
    return SizedBox(
      height: size.height * 0.02,
    );
  }
}
