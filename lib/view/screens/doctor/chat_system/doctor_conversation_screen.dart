import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/screens/doctor/chat_system/doctor_chat_screen.dart';

class DoctorConversationScreen extends StatelessWidget {
  const DoctorConversationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: kDoctorPrimaryColor,
        title: Text('Conversation Screen'),
      ),
      body: ListView.builder(
          // itemCount: conversations.length,
          itemBuilder: (context, index) {
        // Conversation convo = conversations[index];
        // int colorIndex = index % colorsList.length;
        return Card(
          shadowColor: Colors.white54,
          child: ListTile(
            leading: CircleAvatar(
              radius: size.width * 0.08,
              // backgroundColor: colorsList[colorIndex],
              child: Text(
                'pateint first name',
                style: TextStyle(fontSize: 22, color: Colors.white),
              ),
            ),
            title: Text(
              'pateint full name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Last Message'),
            onTap: () => Get.to(() => DoctorChatScreen()),
          ),
          borderOnForeground: true,
        );
      }),
    );
  }
}
