import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/model/conversation_model.dart';
import 'package:medicine_notifier/sizer.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/onBoarding/choose_for_register.dart';
import 'package:medicine_notifier/view/page_animation/custom_page_route.dart';
import 'package:medicine_notifier/view/screens/chat/chat_room_screen.dart';
import 'package:medicine_notifier/view/screens/doctor/chat_system/doctor_conversation_screen.dart';
import 'package:medicine_notifier/view/screens/doctor/registration/doctor_login.dart';
import 'package:medicine_notifier/view/screens/doctor/screens/doctor_home_screen.dart';
import 'package:medicine_notifier/view/screens/doctor/screens/doctor_profile_screen.dart';

class DoctorNavBarScreen extends StatefulWidget {
  @override
  State<DoctorNavBarScreen> createState() => _DoctorNavBarScreenState();
}

class _DoctorNavBarScreenState extends State<DoctorNavBarScreen> {
  PageController controller = PageController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ApiHelper apiHelper = ApiHelper();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: [
              _buildHeader(size),
              SizedBox(
                height: size.height * 0.02,
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Logout'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  apiHelper.logOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      CustomPageRoute(child: ChooseForRegistration()),
                      (route) => false);
                },
              ),
              ListTile(
                leading: Icon(Icons.chat),
                title: Text('Chat'),
                trailing: Icon(Icons.keyboard_arrow_right),
                onTap: () {
                  Get.to(() => DoctorConversationScreen());
                },
              )
            ],
          ),
        ),
        key: scaffoldKey,
        appBar: _currentIndex == 0
            ? AppBar(
                flexibleSpace: _forGradientColor(),
                centerTitle: true,
                title: Text('Home Screen'),
              )
            : PreferredSize(child: SizedBox(), preferredSize: Size(0, 0)),
        body: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: controller,
          children: [DoctorHomeScreen(), DoctorProfileScreen()],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _bottomNavBar(),
      ),
    );
  }

  Container _bottomNavBar() {
    return Container(
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(colors: [
            Colors.teal.shade300,
            kDoctorPrimaryColor,
          ])),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 0;
                });
                controller.jumpToPage(_currentIndex);
              },
              icon: Icon(
                _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 1;
                });
                controller.jumpToPage(1);
              },
              icon: Icon(
                _currentIndex == 1 ? Icons.person : Icons.person_outline,
                size: 30,
              ))
        ],
      ),
    );
  }

  Container _forGradientColor() {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
      Colors.teal.shade300,
      kDoctorPrimaryColor,
    ])));
  }

  Container _buildHeader(Size size) {
    return Container(
      height: size.height * 0.23,
      width: size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.teal.shade300,
        kDoctorPrimaryColor,
      ])),
      child: CircleAvatar(
        radius: size.width * 0.1,
        foregroundImage: AssetImage(
          'assets/no_profile-pic.jpg',
        ),
      ),
    );
  }
}
