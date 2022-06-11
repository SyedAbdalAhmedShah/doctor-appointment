import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/chat_bloc/chat_event.dart';
import 'package:medicine_notifier/blocs/chat_bloc/chat_state.dart';
import 'package:medicine_notifier/model/conversation_model.dart';
import 'package:medicine_notifier/model/doctor_model.dart';
import 'package:medicine_notifier/model/message_model.dart';
import 'package:medicine_notifier/view/components/doctor_manager.dart';

import '../../view/components/strings.dart';

class ChatBloc extends Bloc<ChatEvents, ChatStates> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  ApiHelper apiHelper = ApiHelper();
  ChatBloc(InitialFetchingChatState initialFetchingChatState)
      : super(initialFetchingChatState) {
    on<FetchChatStream>((event, emit) async {
      emit(LoadingFetchingChatState());
      try {
        Stream<List<Messages>> messagesStream =
            await apiHelper.chats(event.conversationID);

        emit(SuccessFetchChatState(stream: messagesStream));
      } catch (error) {
        print('Fetch Chat Stream Error ' + error.toString());
        FailureChatState(error.toString());
      }
    });

    on<SendMessage>((event, emit) async {
      emit(LoadingFetchingChatState());
      try {
        DocumentReference messageRef = firebaseFirestore
            .collection(FirebaseStrings.messageCollection)
            .doc();

        final isUnique = await apiHelper.isAlreadyExsist(event.message, true);
        if (!isUnique) return null;

        DocumentReference doc =
            await apiHelper.storeConversationData(event.message);
        Map<String, dynamic> messagesData =
            apiHelper.storeMessgaes(event.message, messageRef.id, doc.id);
        await messageRef.set(messagesData);
        emit(MessageSavedState());
      } catch (error) {
        print('Message Save State Error ' + error.toString());
        emit(FailureChatState(error.toString()));
      }
    });

    on<IsAlredayExisitConversation>((event, emit) async {
      emit(LoadingFetchingChatState());
      try {
        Conversation convo =
            apiHelper.checkIsAlredayConversated(event.doctorUid, event.userID);
      } catch (error) {
        print(
            'error occured in IsAlredayExisitConversation' + error.toString());
        emit(FailureChatState(error.toString()));
      }
    });

  }
}
