import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/chat_bloc/chat_bloc.dart';
import 'package:medicine_notifier/blocs/chat_bloc/chat_state.dart';
import 'package:medicine_notifier/model/message_model.dart';
import 'package:medicine_notifier/view/components/alert_box.dart';
import 'package:medicine_notifier/view/components/chat_cell.dart';
import 'package:medicine_notifier/view/components/colors_constant.dart';
import 'package:medicine_notifier/view/components/custom_text_field_yellow.dart';
import 'package:medicine_notifier/view/components/doctor_manager.dart';
import 'package:medicine_notifier/view/components/strings.dart';
import 'package:medicine_notifier/view/components/user_manager.dart';

import '../../../blocs/chat_bloc/chat_event.dart';

class ChatScreen extends StatefulWidget {
  final String senderName;
  final String senderID;
  final String conversationID;
  ChatScreen(
      {required this.senderName,
      required this.senderID,
      required this.conversationID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  ChatBloc _chatBloc = ChatBloc(InitialFetchingChatState());
  Stream<List<Messages>>? stream;

  @override
  void initState() {
    if (widget.conversationID.isEmpty && widget.conversationID == null) {
      print('conversation id is empty');
    } else {
      _chatBloc.add(FetchChatStream(conversationID: widget.conversationID));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(widget.senderName),
        ),
        body: BlocListener(
          bloc: _chatBloc,
          listener: (context, state) {
            if (state is LoadingFetchingChatState) {
              _buildLoader();
            }
            if (state is SuccessFetchChatState) {
              stream = state.stream;
            }
            if (state is FailureChatState) {
              Alert.dialogBox(errormessage: state.message, context: context);
            }
          },
          child: BlocBuilder(
              bloc: _chatBloc,
              builder: (context, state) {
                return _buildStremBuilder(size);
              }),
        ));
  }

  Center _buildLoader() => Center(
        child: CupertinoActivityIndicator(),
      );

  StreamBuilder<List<Messages>> _buildStremBuilder(Size size) {
    return StreamBuilder(
        stream: stream,
        builder: (context, AsyncSnapshot<List<Messages>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoader();
          }

          List<Messages> messages = snapshot.data!;

          return _buildBody(context, size, messages);
        });
  }

  Column _buildBody(BuildContext context, Size size, List<Messages> messages) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
                itemCount: messages.length,
                reverse: true,
                itemBuilder: (context, index) {
                  Messages message = messages[index];
                  return ChatCell(
                    messages: message,
                  );
                })),
        Row(
          children: [
            Container(
              height: size.height * 0.11,
              width: size.width * 0.8,
              child: CustomeTextFieldWthOrangeBorder(
                  controller: messageController,
                  borderColor: kPrimaryColor,
                  labelName: 'write a message',
                  validator: (value) {}),
            ),
            ElevatedButton(
                onPressed: () async {
                  Messages messages = getMessageModel();
                  if (messageController.text.isNotEmpty) {
                    _chatBloc.add(SendMessage(message: messages));
                    messageController.clear();
                  } else {
                    CupertinoActionSheet(
                      message: Text('jjjj'),
                      title: Text('jjj'),
                    );
                    // Alert.dialogBox(
                    //     errormessage: 'Do You Want to send Empty Text',
                    //     context: context,
                    //     onTap: () {
                    //       _chatBloc.add(SendMessage(message: messages));
                    //       Get.back();
                    // }

                  }
                },
                child: Icon(Icons.send))
          ],
        )
      ],
    );
  }

  getMessageModel() {
    Messages messages = Messages();

    messages.description = messageController.text;
    messages.targetUserId = widget.senderID;
    messages.userId = UserManager.user != null
        ? UserManager.user.uid
        : DoctorManager.doctor.uid;
    messages.userName = UserManager.user != null
        ? UserManager.user.patientName
        : DoctorManager.doctor.doctorName;
    return messages;
  }
}
