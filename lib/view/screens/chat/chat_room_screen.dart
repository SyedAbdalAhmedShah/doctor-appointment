import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:medicine_notifier/blocs/conversation_bloc/conversation_bloc.dart';
import 'package:medicine_notifier/blocs/conversation_bloc/conversation_events.dart';
import 'package:medicine_notifier/blocs/conversation_bloc/conversation_states.dart';
import 'package:medicine_notifier/model/conversation_model.dart';
import 'package:medicine_notifier/view/components/alert_box.dart';
import 'package:medicine_notifier/view/components/doctor_manager.dart';
import 'package:medicine_notifier/view/components/strings.dart';
import 'package:medicine_notifier/view/components/user_manager.dart';
import 'package:medicine_notifier/view/screens/chat/Chat_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  late ConversationBloc _bloc = ConversationBloc(ConversationInitialState());
  List<Color> colorsList = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.purple
  ];

  @override     
  void initState() {
    print('usermanager user id ' + UserManager.user.uid.toString());
    print('doctor id is  ' + DoctorManager.doctor.uid.toString());
    print('doctor logged in  ' + DoctorManager.isDoctorLogedIn.toString());
    String Id = DoctorManager.isDoctorLogedIn
        ? DoctorManager.doctor.uid.toString()
        : UserManager.user.uid.toString();
    _bloc.add(ConversationByUserId(userID: Id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(
            FirebaseStrings.chats,
            style: TextStyle(fontSize: 25),
          ),
          centerTitle: true,
        ),
        body: BlocConsumer(
            bloc: _bloc,
            listener: (context, state) {
              print('state is :' + state.toString());
            },
            builder: (context, state) {
              if (state is ConversationLoadingState) {
                return Center(
                  child: CupertinoActivityIndicator(),
                );
              }
              if (state is ConversationSuccessState) {
                return _buildBody(
                  colorsList: colorsList,
                  size: size,
                  conversations: state.conversaions,
                );
              }
              if (state is ConversationFailureStates) {
                return Alert.dialogBox(
                    errormessage: state.message, context: context);
              }
              return SizedBox();
            }));
  }
}

class _buildBody extends StatelessWidget {
  const _buildBody(
      {Key? key,
      required this.colorsList,
      required this.size,
      required this.conversations})
      : super(key: key);

  final List<Color> colorsList;
  final Size size;
  final List<Conversation> conversations;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          Conversation convo = conversations[index];
          int colorIndex = index % colorsList.length;
          return Card(
            shadowColor: Colors.white54,
            child: ListTile(
              leading: CircleAvatar(
                radius: size.width * 0.08,
                backgroundColor: colorsList[colorIndex],
                child: Text(
                  '${convo.doctorName![0].toUpperCase()}',
                  style: TextStyle(fontSize: 22, color: Colors.white),
                ),
              ),
              title: Text(
                '${convo.doctorName}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Last Message'),
              onTap: () => Get.to(ChatScreen(
                senderName: convo.doctorName!,
                senderID: convo.doctorUid!,
                conversationID: convo.conversationID!,
              )),
            ),
            borderOnForeground: true,
          );
        });
  }
}
