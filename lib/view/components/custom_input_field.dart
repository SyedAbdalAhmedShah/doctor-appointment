import 'package:flutter/material.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:sizer/sizer.dart';

class InputFieldReuse extends StatelessWidget {
  final String title;
  final String? hint;
  final TextEditingController? controller;
  final Widget? widget;
  final TextInputType? keyboardTye;
  InputFieldReuse(
      {required this.title,
      required this.hint,
      this.controller,
      this.widget,
      this.keyboardTye});

  @override
  Widget build(BuildContext context) {
    return Container(
        // margin: EdgeInsets.symmetric(vertical: size.convert(context, 10)),
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Colors.white)),
        Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  print(value);
                },
                controller: controller,
                readOnly: widget == null ? false : true,
                keyboardType: keyboardTye,
                decoration: InputDecoration(
                  hintStyle: TextStyle(color: Colors.white60),
                  hintText: hint,
                  suffixIcon: widget,
                  // suffixIcon: widget == null
                  //     ? Container()
                  //     : Container(child: widget),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: kTextColor),
                  ),
                  focusColor: Colors.grey,
                  focusedBorder: _outlineBorder(),
                  contentPadding: const EdgeInsets.all(10),
                  border: _outlineBorder(),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }

  OutlineInputBorder _outlineBorder() {
    return const OutlineInputBorder(borderSide: BorderSide(color: kTextColor));
  }
}
