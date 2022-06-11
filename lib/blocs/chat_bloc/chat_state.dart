import 'package:medicine_notifier/model/message_model.dart';

abstract class ChatStates {}

class InitialFetchingChatState extends ChatStates {}

class LoadingFetchingChatState extends ChatStates {}

class SuccessFetchChatState extends ChatStates {
  final Stream<List<Messages>> stream;

  SuccessFetchChatState({required this.stream});
}

class FailureChatState extends ChatStates {
  final String message;
  FailureChatState(this.message);
}

class MessageSavedState extends ChatStates {}
