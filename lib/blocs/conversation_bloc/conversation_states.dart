import 'package:flutter/rendering.dart';
import 'package:medicine_notifier/model/conversation_model.dart';

abstract class ConversationStates {}

class ConversationInitialState extends ConversationStates {}

class ConversationLoadingState extends ConversationStates {}

class ConversationSuccessState extends ConversationStates {
  List<Conversation> conversaions = [];
  ConversationSuccessState({required this.conversaions});
}

class ConversationFailureStates extends ConversationStates {
  final String message;
  ConversationFailureStates({required this.message});
}
