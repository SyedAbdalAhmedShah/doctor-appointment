import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/blocs/login_bloc/login_bloc.dart';
import 'package:medicine_notifier/blocs/login_bloc/login_event.dart';
import 'package:medicine_notifier/blocs/login_bloc/login_state.dart';
import 'package:medicine_notifier/blocs/signup_bloc/signup_bloc.dart';
import 'package:medicine_notifier/blocs/signup_bloc/signup_event.dart';

import 'package:medicine_notifier/local%20database/shared_prefrences.dart';
import 'package:medicine_notifier/view/components/alert_box.dart';
import 'package:medicine_notifier/view/components/button.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/components/doctor_mybutton.dart';

import 'package:medicine_notifier/view/page_animation/custom_page_route.dart';
import 'package:medicine_notifier/view/screens/doctor/home_page/doctor_Navbar_screen.dart';

import 'package:medicine_notifier/view/screens/doctor/registration/doctor_singup.dart';
import 'package:medicine_notifier/view/screens/patient/nav_bar_screens/nav_bar_all_screens.dart';

import 'package:sizer/sizer.dart';

class DoctorLogin extends StatelessWidget {
  LoginBloc _bloc = LoginBloc();

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(systemStatusBarContrastEnforced: false),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(
              Icons.arrow_back,
              color: kDoctorPrimaryColor,
            )),
        title: Text(
          'Doctor Login',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.sp,
              color: kDoctorPrimaryColor,
              shadows: [Shadow(offset: Offset(-1, 2))]),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // TitleWidget(
              //   title: "Login",
              // ),
              SizedBox(
                height: screenHeight * 0.2,
              ),
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.person_outline,
                          color: kDoctorPrimaryColor),
                      labelText: 'Email',
                      labelStyle: TextStyle(color: kTextColor),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: kDoctorPrimaryColor,
                          ),
                          borderRadius: BorderRadius.circular(20.sp)),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(20.sp))),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.sp),
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                      suffixIcon: Icon(Icons.remove_red_eye_outlined,
                          color: kDoctorPrimaryColor),
                      labelText: 'Password',
                      labelStyle: TextStyle(color: kTextColor),
                      focusedBorder: _outlineBorder(),
                      border: _outlineBorder()),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),

              BlocConsumer(
                bloc: _bloc,
                listener: (context, state) {
                  if (state is LoginLoadingState) {
                    print(state);
                    CupertinoActivityIndicator();
                  }
                  if (state is LoginFailureState) {
                    Alert.dialogBox(
                        errormessage: state.error, context: context);
                  }
                  if (state is LoginSuccessState) {
                    Navigator.of(context)
                        .push(CustomPageRoute(child: DoctorNavBarScreen()));
                  }

                  // TODO: implement listener
                },
                builder: (context, state) {
                  return DoctorMyButton(
                    child: _bloc.state is LoginLoadingState
                        ? CupertinoActivityIndicator()
                        : Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500),
                          ),
                    ontap: () {
                      print('loinnnn');

                      print(email.text);

                      print(password.text);

                      _bloc.add(DoctorLoginEvent(
                          email: email.text, password: password.text));
                    },
                  );
                },
              ),

              SizedBox(
                height: screenHeight * 0.2,
              ),

              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Don???t have an account?',
                    style: TextStyle(fontSize: 12.sp)),
                GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(CustomPageRoute(child: DoctorSignUp()));
                    },
                    child: Text(' Sign Up',
                        style: TextStyle(
                            fontSize: 12.sp, color: kDoctorTextColor))),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _outlineBorder() {
    return OutlineInputBorder(
        borderSide: BorderSide(color: kDoctorPrimaryColor),
        borderRadius: BorderRadius.circular(20.sp));
  }

  // loginButton() {
  //   return
  // }
}
