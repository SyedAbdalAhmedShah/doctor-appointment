abstract class ConversationEvents {}

class ConversationByUserId extends ConversationEvents {
  final String userID;

  ConversationByUserId({
    required this.userID,
  });
}

class ConversationByDoctorId extends ConversationEvents {
  final String doctorID;
  ConversationByDoctorId({required this.doctorID});
}
