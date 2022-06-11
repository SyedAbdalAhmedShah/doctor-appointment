import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicine_notifier/blocs/make_appoinment_bloc/make_appoinment_state.dart';
import 'package:medicine_notifier/model/conversation_model.dart';
import 'package:medicine_notifier/model/doctor_model.dart';
import 'package:medicine_notifier/model/make_appoinment.dart';
import 'package:medicine_notifier/model/message_model.dart';
import 'package:medicine_notifier/model/my_appoinment_model.dart';
import 'package:medicine_notifier/model/patient_model.dart';
import 'package:medicine_notifier/view/components/strings.dart';
import 'package:medicine_notifier/view/components/user_manager.dart';
import 'package:medicine_notifier/view/screens/patient/appoinments/my_appoinments.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiHelper {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future storePatientInformation(PatientModel patientModel, String uid) async {
    final patientDetails = Map<String, Object>();
    patientDetails['city'] = patientModel.city!;
    patientDetails['country'] = patientModel.country!;
    patientDetails['email'] = patientModel.email!;
    patientDetails['profileImage'] = patientModel.profileImage!;
    patientDetails['patientName'] = patientModel.patientName!;
    patientDetails['uid'] = patientModel.uid!;

    firestore
        .collection(FirebaseStrings.patientCollection)
        .doc(uid)
        .set(patientDetails);
  }

  Future storeDoctorInformation(
    DoctorModel doctor,
    String uid,
  ) async {
    final doctorDetail = Map<String, Object>();

    doctorDetail['doctorName'] = doctor.doctorName!;
    doctorDetail['clinicName'] = doctor.clinicName!;
    doctorDetail['email'] = doctor.email!;
    doctorDetail['speciality'] = doctor.speciality!;
    doctorDetail['uid'] = doctor.uid!;

    final userCredential = await firestore
        .collection(FirebaseStrings.doctorsCollection)
        .doc(uid)
        .set(doctorDetail);

    print('inserteddd ');

    return userCredential;
  }

  Future storePatientDataInToFirebase(
    PatientModel patientModel,
    String uid,
  ) async {
    final userCredential = await firestore
        .collection(FirebaseStrings.patientCollection)
        .doc(uid)
        .set(patientModel.userBashicInfo())
        .then((value) => print('inserteddd patient data  in firebase'));

    return userCredential;
  }

  Future<void> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    auth.signOut();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getPatientAfterLogin(
      String uid) async {
    DocumentSnapshot<Map<String, dynamic>> patient = await firestore
        .collection(FirebaseStrings.patientCollection)
        .doc(uid)
        .get();
    return patient;
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getDocotrDataAfterLogin(
      String uid) async {
    DocumentSnapshot<Map<String, dynamic>> doctor = await firestore
        .collection(FirebaseStrings.doctorsCollection)
        .doc(uid)
        .get();
    return doctor;
  }

  Future<void> makeAppoinment(
      {required Map<String, dynamic> data, required String uid}) async {
    await firestore
        .collection(FirebaseStrings.appoinments)
        .doc()
        .set(data)
        .catchError((error) {
      print('firebase error in aapi $error');
    }).whenComplete(() => print('appoinment inserted'));
  }

  Future<List<DoctorModel>> getDoctorDetails(String doctorUid) async {
    final collection =
        await firestore.collection(FirebaseStrings.doctorsCollection).get();
    final doctorFound = collection.docs
        .where((element) => element.get('uid') == doctorUid)
        .toList();

    final mapedDoctor =
        doctorFound.map((e) => DoctorModel.fromJson(e.data())).toList();
    print(mapedDoctor.first.doctorName);

    return mapedDoctor;
  }

  Future<List<MyAppoinments>> getMyAppoinments() async {
    final collection =
        await firestore.collection(FirebaseStrings.appoinments).get();
    List<QueryDocumentSnapshot<Map<String, dynamic>>> appointments = collection
        .docs
        .where((element) => element.get('patientUid') == UserManager.user.uid)
        .toList();
    appointments.forEach((element) {
      print("=============   ${element.data()['Status']}");
    });
    List<MyAppoinments> appoinmentsList =
        appointments.map((e) => MyAppoinments.fromJson(e.data())).toList();
    print(appoinmentsList);

    return appoinmentsList;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getDoctorInAppointById(String uid) async {
    final documents = await firestore
        .collection(FirebaseStrings.appoinments)
        .orderBy('timeStamp', descending: true)
        .get();
    final myappoinment = documents.docs
        .where((element) => element.get('doctorUid') == uid)
        .toList();
    return myappoinment;
  }

  Future<void> updateTheAppointmentStatus(
      {required String uid,
      required int index,
      required String statusResponse}) async {
    final myappoinment = await getDoctorInAppointById(uid);

    print(myappoinment[index].data());
    myappoinment[index].reference.update({'Status': statusResponse});
  }

  Future<List<DoctorModel>> getDoctorbyNameThroughQuery(String query) async {
    print("query========$query");
    final fireBasequery =
        await firestore.collection(FirebaseStrings.doctorsCollection).get();
    final docs = fireBasequery.docs;
    // final searchDoctor =
    //     docs.where((element) => element.data()['doctorName'] == query).toList();

    // print("searchDoctor===========$searchDoctor");
    final doctors = docs.map((e) => DoctorModel.fromJson(e.data())).toList();
    final searchDoctors = doctors
        .where((element) =>
            element.doctorName!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    print("searchhhhh doctors is ===========$searchDoctors");
    return searchDoctors;
  }

  //----------------Streamss---------------------------//

  Stream<List<MyAppoinments>> getAppointmentForSpecificDoctor(String uid) {
    final appoinmentCollection =
        firestore.collection(FirebaseStrings.appoinments);
    Query query = appoinmentCollection.where(
      'doctorUid',
      isEqualTo: uid,
    );

    Stream<QuerySnapshot> stream =
        query.orderBy(FirebaseStrings.timeStamp, descending: true).snapshots();
    print(stream);
    return stream.map((qShot) => qShot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          MyAppoinments myAppoinments = MyAppoinments();
          try {
            myAppoinments.pateintName = data[FirebaseStrings.patientName];
            myAppoinments.patientUid = data[FirebaseStrings.patientUid];
            myAppoinments.status = data[FirebaseStrings.status];
            myAppoinments.time = data[FirebaseStrings.time];
            myAppoinments.pateintAge = data[FirebaseStrings.patientAge];
            myAppoinments.doctorUid = data[FirebaseStrings.doctorUid];
            myAppoinments.disease = data[FirebaseStrings.diesease];
            myAppoinments.description = data[FirebaseStrings.description];
            myAppoinments.date = data[FirebaseStrings.date];
          } catch (e) {
            print("Exception While data conversion: " + e.toString());
          }

          return myAppoinments;
        }).toList());
  }

  // getConversationById(Conversation conversation) {
  //   firestore
  //       .collection(FirebaseStrings.ConversationCollection)
  //       .where(FirebaseStrings.userID, isEqualTo: conversation.conversationID)
  //       .get();
  // }

  Stream<List<Messages>> chats(String convoID) {
    final chatCollection =
        firestore.collection(FirebaseStrings.messageCollection);
    Query query = chatCollection
        .where(FirebaseStrings.conversationID, isEqualTo: convoID)
        .orderBy('dateTime', descending: true);
    Stream<QuerySnapshot> stream = query.snapshots();
    return stream.map((qShot) => qShot.docs.map((e) {
          var data = e.data() as Map<String, dynamic>;

          print('description : ' + data['description']);
          Messages messages = Messages();
          try {
            messages.userName = data[FirebaseStrings.userName];
            messages.userId = data[FirebaseStrings.userID];
            messages.dateTime = data[FirebaseStrings.dateTime];
            messages.description = data['description'];
            messages.targetUserId = data[FirebaseStrings.targetUserId];
            messages.messageId = data[FirebaseStrings.messageId];
          } catch (error) {
            print("Exception While data conversion: " + error.toString());
          }
          return messages;
        }).toList());
  }

  Map<String, dynamic> storeMessgaes(
      Messages message, String id, String conversationID) {
    final messageData = Map<String, dynamic>();
    messageData[FirebaseStrings.conversationID] = conversationID;
    messageData[FirebaseStrings.messageId] = id;
    messageData[FirebaseStrings.description] = message.description;
    messageData[FirebaseStrings.dateTime] = Timestamp.now();
    messageData[FirebaseStrings.userName] = message.userName;

    messageData[FirebaseStrings.userID] = message.userId;

    messageData[FirebaseStrings.targetUserId] = message.targetUserId;

    return messageData;
  }

  Future<bool> isAlreadyExsist(Messages messages, bool isForMessage) async {
    QuerySnapshot doc = await firestore
        .collection(FirebaseStrings.ConversationCollection)
        .where(FirebaseStrings.doctorUid, isEqualTo: messages.targetUserId)
        .where(FirebaseStrings.userID, isEqualTo: messages.userId)
        .get();

    DocumentReference msgDoc =
        firestore.collection(FirebaseStrings.messageCollection).doc();

    if (doc.docs.length > 0) {
      print('document exisit , ID is :' + doc.docs.first.id);
      if (isForMessage) {
        Map<String, dynamic> messagesData =
            storeMessgaes(messages, msgDoc.id, doc.docs.first.id);
        await msgDoc.set(messagesData);
      }

      return false;
    } else {
      print('not exsit');
      return true;
    }
  }

  checkIsAlredayConversated(String doctorUid, String userID) async {
    QuerySnapshot doc = await firestore
        .collection(FirebaseStrings.ConversationCollection)
        .where(FirebaseStrings.doctorUid, isEqualTo: doctorUid)
        .where(FirebaseStrings.userID, isEqualTo: doctorUid)
        .get();
    print(doc.docs.length.toString() + ' convo length');
    doc.docs.forEach((element) {
      final mapData = element.data() as Map<String, dynamic>;
      final convo = Conversation.fromJson(mapData);

      print(convo);
    });
  }

  Future<DocumentReference> storeConversationData(Messages messages) async {
    DocumentReference doc =
        firestore.collection(FirebaseStrings.ConversationCollection).doc();
    DoctorModel doctors = await getDoctorById(messages.targetUserId!);
    final conversationMap = Map<String, dynamic>();
    conversationMap[FirebaseStrings.conversationID] = doc.id;
    conversationMap[FirebaseStrings.doctorName] = doctors.doctorName;
    conversationMap[FirebaseStrings.userID] = messages.userId;
    conversationMap[FirebaseStrings.date] = DateTime.now();
    conversationMap[FirebaseStrings.doctorUid] = messages.targetUserId;
    await doc.set(conversationMap);

    return doc;
  }

  getDoctorById(String doctorId) async {
    final doc = firestore.collection(FirebaseStrings.doctorsCollection);
    Query<Map<String, dynamic>> query = doc.where('uid', isEqualTo: doctorId);
    final ref = await query.get();
    final data = ref.docChanges.first.doc;
    print(ref.docChanges.first.doc.data());
    final doctor = DoctorModel.fromJson(data.data()!);
    print(doctor.doctorName);
    // print('doctor by id is :' + doctor.doctorName.toString());
    return doctor;
  }

  Future<List<Conversation>> conversationByUserid(String userID) async {
    List<Conversation> conversations = [];
    CollectionReference col =
        await firestore.collection(FirebaseStrings.ConversationCollection);
    QuerySnapshot querySnapshot =
        await col.where(FirebaseStrings.userID, isEqualTo: userID).get();

    print(querySnapshot.docs.length);
    querySnapshot.docs.forEach((qshot) {
      final mapData = qshot.data() as Map<String, dynamic>;
      final convertedConversation = Conversation.fromJson(mapData);
      print(convertedConversation);
      conversations.add(convertedConversation);
      ;
    });
    print(conversations);
    return conversations;
  }

  Future<List<Conversation>> conversationByDoctorId(String doctorID) async {
    List<Conversation> conversations = [];
    CollectionReference col =
        await firestore.collection(FirebaseStrings.ConversationCollection);
    QuerySnapshot querySnapshot =
        await col.where(FirebaseStrings.doctorUid, isEqualTo: doctorID).get();
    querySnapshot.docs.forEach((qshot) {
      final mapData = qshot.data() as Map<String, dynamic>;
      final convertedConversation = Conversation.fromJson(mapData);
      print(convertedConversation);
      conversations.add(convertedConversation);
      ;
    });
    print(conversations);
    return conversations;
  }
}
