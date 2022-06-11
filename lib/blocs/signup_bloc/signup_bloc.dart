import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:medicine_notifier/Repository/api_helper.dart';
import 'package:medicine_notifier/blocs/signup_bloc/signup_event.dart';
import 'package:medicine_notifier/blocs/signup_bloc/signup_states.dart';
import 'package:bloc/bloc.dart';
import 'package:medicine_notifier/model/doctor_model.dart';
import 'package:medicine_notifier/model/patient_model.dart';
import 'package:medicine_notifier/view/components/doctor_manager.dart';
import 'package:medicine_notifier/view/components/strings.dart';
import 'package:medicine_notifier/view/components/user_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SingupBloc extends Bloc<SingupEvent, SignUpState> {
  SingupBloc() : super(InitialSignupState());

  // Repository repository = Repository();
  FirebaseAuth _auth = FirebaseAuth.instance;
  ApiHelper repository = ApiHelper();
  FirebaseStorage storage = FirebaseStorage.instance;
  String firebaseImagePath = '';

  Stream<SignUpState> mapEventToState(SingupEvent event) async* {
    if (event is UserSingupEvent) {
      yield LoadingSingupState();
      try {
        await uploadImage(
            imageName: event.imageName, imagePath: event.imagePath);

        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: event.patientModel.email!,
          password: event.password,
        );
        print("pateint save in db ========== ${credential}");
        final pateintDetails =
            await savePatientToDB(event.patientModel, credential);
        print("pateint save in db ========== ${pateintDetails}");

        repository.storePatientDataInToFirebase(
            pateintDetails, credential.user!.uid);
        print('successfull');
        yield SuccessSingupState();
      } on FirebaseAuthException {
      } catch (error) {
        print("signUpError in bloc patienttt======== ${error.toString()}");
        yield FailureSingupState(message: error.toString());
      }
    }

    if (event is DoctorSignupEvent) {
      yield LoadingSingupState();
      try {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: event.email, password: event.password);

        DoctorModel doctorDetail =
            await saveDoctorToDB(event.doctorModel, credential);

        print('detail doctorrr saveed in db $doctorDetail');

        final record = await repository.storeDoctorInformation(
          doctorDetail,
          credential.user!.uid,
        );
        print("Doctor Credential ========== ${credential.user!}");

        print('doctor Record inserted ========== $record');
        yield SuccessSingupState();
      } catch (error) {
        print("signUpError in bloc doctorrrrr ======== ${error.toString()}");

        yield FailureSingupState(message: error.toString());
      }
    }
  }

  Future<DoctorModel> saveDoctorToDB(
      DoctorModel doctorCredentials, UserCredential firebaseUser) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    DoctorModel doctorData = DoctorModel(
        clinicName: doctorCredentials.clinicName,
        uid: firebaseUser.user!.uid,
        email: firebaseUser.user!.email,
        speciality: doctorCredentials.speciality,
        doctorName: doctorCredentials.doctorName);

    final isLogedIn =
        await sharedPreferences.setBool(FirebaseStrings.isDoctorLogedIn, true);
    sharedPreferences.setString(
        FirebaseStrings.doctorKey, json.encode(doctorData.toJson()));

    DoctorManager.doctor = doctorData;

    DoctorManager.isDoctorLogedIn = isLogedIn;
    return doctorData;
  }

  Future<PatientModel> savePatientToDB(
      PatientModel patientModel, UserCredential credential) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    PatientModel patients = PatientModel(
        city: patientModel.city,
        country: patientModel.country,
        patientName: patientModel.patientName,
        uid: credential.user!.uid,
        email: credential.user!.email,
        profileImage: firebaseImagePath);

    final isLogedIn =
        await sharedPreferences.setBool(FirebaseStrings.isLogedIn, true);
    sharedPreferences.setString(
        FirebaseStrings.userKey, json.encode(patients.userBashicInfo()));

    UserManager.user = patients;

    UserManager.isUserLogedIn = isLogedIn;

    return patients;
  }

  Future uploadImage(
      {required String imageName, required String imagePath}) async {
    final refrence = storage.ref().child('patientImages').child(imageName);

    UploadTask uploadTask = refrence.putFile(File(imagePath));

    print('user image url ======== ${uploadTask.storage.bucket}');
    await uploadTask.whenComplete(() async {
      final imageurl = await storage
          .ref()
          .child('patientImages')
          .child(imageName)
          .getDownloadURL();

      firebaseImagePath = imageurl;
      print(firebaseImagePath);
    });
  }
}
