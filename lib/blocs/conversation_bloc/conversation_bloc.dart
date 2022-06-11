import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/conversation_bloc/conversation_events.dart';
import 'package:medicine_notifier/blocs/conversation_bloc/conversation_states.dart';
import 'package:medicine_notifier/model/conversation_model.dart';

class ConversationBloc extends Bloc<ConversationEvents, ConversationStates> {
  ApiHelper repo = ApiHelper();

  ConversationBloc(ConversationStates initialState) : super(initialState) {
    on<ConversationByUserId>((event, emit) async {
      emit(ConversationLoadingState());
      try {
        List<Conversation>? convs;

        convs = await repo.conversationByUserid(event.userID); 

        emit(ConversationSuccessState(conversaions: convs));
      } catch (error) {
        print('error occure conversation by user id event ' + error.toString());
        emit(ConversationFailureStates(message: error.toString()));
      }
    });

    on<ConversationByDoctorId>((event, emit) async {
      emit(ConversationLoadingState());
      try {
        List<Conversation> convs =
            await repo.conversationByDoctorId(event.doctorID);
        emit(ConversationSuccessState(conversaions: convs));
      } catch (error) {
        print(
            'error occure conversation by doctor id event ' + error.toString());
        emit(ConversationFailureStates(message: error.toString()));
      }
    });
  }
}
