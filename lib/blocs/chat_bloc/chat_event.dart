import 'package:medicine_notifier/model/message_model.dart';

abstract class ChatEvents {}

class FetchChatStream extends ChatEvents {
  final String conversationID;
  FetchChatStream({required this.conversationID});
}

class SendMessage extends ChatEvents {
  final Messages message;
  SendMessage({required this.message});
}

class GetConversationByUser extends ChatEvents {}

class IsAlredayExisitConversation extends ChatEvents {
  final String doctorUid;
  final String userID;
  IsAlredayExisitConversation({required this.doctorUid, required this.userID});
}

