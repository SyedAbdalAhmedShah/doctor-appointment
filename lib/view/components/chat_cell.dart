import 'package:flutter/material.dart';
import 'package:medicine_notifier/model/message_model.dart';
import 'package:medicine_notifier/view/components/user_manager.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatCell extends StatelessWidget {
  final Messages messages;
  ChatCell({required this.messages});
  bool isMe() {
    if (messages.userName == UserManager.user.patientName &&
        messages.userId == UserManager.user.uid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return _buildBody(size);
  }

  Row _buildBody(Size size) {
    return Row(
      mainAxisAlignment:
          isMe() ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.009),
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.03, vertical: size.height * 0.02),
          decoration: _decoration(size),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _userPicAndName(size),
              SizedBox(
                height: size.height * 0.01,
              ),
              _descriptionAndTimeAgo(size),
            ],
          ),
        ),
      ],
    );
  }

  BoxDecoration _decoration(Size size) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
            color: isMe()
                ? Color.fromARGB(255, 62, 104, 138)
                : Colors.grey.shade700,
            spreadRadius: 0.8,
            blurRadius: 7.0,
            offset: Offset(3.0, 3.0)),
      ],
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(size.width * 0.02),
          bottomLeft: Radius.circular(size.width * 0.02)),
      color: isMe()
          ? Color.fromARGB(77, 32, 35, 124)
          : Color.fromARGB(255, 157, 206, 247),
    );
  }

  Row _userPicAndName(Size size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: size.width * 0.03,
          foregroundImage: AssetImage('assets/no_picture.png'),
        ),
        SizedBox(
          width: size.width * 0.01,
        ),
        Text('${isMe() ? 'me' : messages.userName}')
      ],
    );
  }

  Row _descriptionAndTimeAgo(Size size) {
    return Row(
      children: [
        Text(
          "${messages.description}",
          style: TextStyle(color: isMe() ? Colors.white : Colors.black),
        ),
        SizedBox(
          width: size.width * 0.02,
        ),
        Text(
          timeago
              .format(messages.dateTime!.toDate())
              .replaceAll('minutes', 'min'),
          style: TextStyle(
            color: Colors.grey.shade700,
          ),
          maxLines: 30,
        )
      ],
    );
  }
}
