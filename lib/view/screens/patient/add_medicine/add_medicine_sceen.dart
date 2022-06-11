import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:medicine_notifier/controller/add_medicine_controller.dart';
import 'package:medicine_notifier/local%20database/local_database.dart';
import 'package:medicine_notifier/model/add_medicine.dart';
import 'package:medicine_notifier/view/components/custom_input_field.dart';
import 'package:medicine_notifier/view/components/my_button.dart';
import 'package:sizer/sizer.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class AddMedicinePage extends StatefulWidget {
  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

DbHelper dbHelper = DbHelper();
int notificationId = 0;

class _AddMedicinePageState extends State<AddMedicinePage> {
  TextEditingController tabletController = TextEditingController();
  TextEditingController doctorController = TextEditingController();
  TextEditingController totalTabController = TextEditingController();

  final findController = Get.find<MedicineController>();

  DateTime _selectedDate = DateTime.now();
  String endTime = DateFormat('h:mm a').format(DateTime.now()).toString();
  String startTime = DateFormat('h:mm a').format(DateTime.now()).toString();
  int _selectedReminder = 5;
  List<int> reminderList = [5, 10, 15, 20];

  int notificationHour = 0;
  int notificationMinutes = 0;
  String _selectedRepeat = 'daily';
  List<String> repeatList = [
    'none',
    'daily',
    'weekly',
    'monthly',
  ];
  int selectedColor = 0;

  FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final controller = Get.put(MedicineController());

  @override
  void initState() {
    print('notification initializing');
    initialized();
    tz.initializeTimeZones();
    print('notification initializing completed');
    super.initState();
  }

  Future<void> showNotification(DateTime dateTime, int notificationId) async {
    var dateTime = DateTime(DateTime.now().year, DateTime.now().month,
        DateTime.now().day, notificationHour, notificationMinutes, 0);

    try {
      localNotificationsPlugin.zonedSchedule(
        notificationId,
        '${tabletController.text}',
        'Its time to take your ${tabletController.text}',

        tz.TZDateTime.from(dateTime, tz.local),
        NotificationDetails(
            android: AndroidNotificationDetails(
          'channel Id',
          'channel Name',
          channelDescription: 'channel  Description',
          visibility: NotificationVisibility.public,
          ticker: 'yes',
          color: Colors.red,
          channelShowBadge: true,
          enableLights: true,
          enableVibration: true,
          importance: Importance.max,
        )),
        payload: 'Panadol',

        matchDateTimeComponents: DateTimeComponents.time,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        // uiLocalNotificationDateInterpretation:
        //     UILocalNotificationDateInterpretation.wallClockTime,
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void initialized() async {
    var initializedAndroid = AndroidInitializationSettings('ic_launcher');
    var initializedSettings =
        InitializationSettings(android: initializedAndroid);
    await localNotificationsPlugin.initialize(initializedSettings);
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(seconds: 2))
        : scheduledDate;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      height: screenHeight * 0.8,
      padding: EdgeInsetsDirectional.all(8),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.cancel,
                      color: Colors.white,
                    )),
              ],
            ),
            SizedBox(
              height: screenHeight * 0.04,
            ),
            InputFieldReuse(
              title: 'Tabelt Name',
              hint: 'Enter tablet name  here',
              controller: tabletController,
            ),
            SizedBox(
              height: 2.h,
            ),
            InputFieldReuse(
              title: 'Dotcor name  ',
              hint: 'Enter doctor name  here',
              controller: doctorController,
            ),
            SizedBox(
              height: 2.h,
            ),
            InputFieldReuse(
              title: 'Total tablets  ',
              hint: 'Enter total number of tablets ',
              controller: totalTabController,
              keyboardTye: TextInputType.number,
            ),
            SizedBox(
              height: 2.h,
            ),

            startAndEndTIme(),
            SizedBox(
              height: 2.h,
            ),
            // reminder(),
            // SizedBox(
            //   height: 2.h,
            // ),
            // repeater(),
            // SizedBox(
            //   height: 2.h,
            // ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButton(
                  label: 'Create Task',
                  onTap: validator,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  validator() async {
    setState(() {
      notificationId++;
    });

    print('ontab');
    if (tabletController.text.isNotEmpty &&
        doctorController.text.isNotEmpty &&
        totalTabController.text.isNotEmpty) {
      await showNotification(DateTime.now(), notificationId);
      final result = await dbHelper.insertData(
        AddMedicineModel(
          doctorName: doctorController.text,
          totalTablet: int.parse(totalTabController.text),
          tabletName: tabletController.text,
          time: endTime,
        ),
      );
      print('inserted record id = $result');
      findController.getAllRecord();

      Get.back();
    } else {
      Get.snackbar(
        'Error',
        'please fill all the fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
    }
  }
  // validator() async {
  //   if (titleController.text.isNotEmpty && noteController.text.isNotEmpty) {
  //     await _addTaskToDb();
  //     controller.showAllDataFromDb();
  //     // await DbHelper.getAllDataFromDb();
  //     Get.back();
  //   } else {
  //     Get.snackbar('error', 'some fields is emply ',
  //         backgroundColor: Get.isDarkMode ? Colors.white : Colors.black,
  //         icon: Icon(
  //           Icons.error,
  //           color: Colors.red,
  //         ),
  //         padding: EdgeInsets.symmetric(vertical: 10),
  //         colorText: Colors.red,
  //         snackPosition: SnackPosition.BOTTOM);
  //   }
  // }

  // _addTaskToDb() async {
  //   int value = await taskController.addTask(
  //       task: Task(
  //           title: titleController.text,
  //           note: noteController.text,
  //           startDate: startTime,
  //           endTime: endTime,
  //           remind: _selectedReminder,
  //           repeat: _selectedRepeat,
  //           date: DateFormat.yMd().format(_selectedDate),
  //           color: selectedColor,
  //           isCompleted: 0));

  //   print('inserted record where id = $value');
  // }

  InputFieldReuse repeater() {
    return InputFieldReuse(
      title: 'Repeat',
      hint: _selectedRepeat,
      widget: DropdownButton(
          underline: Container(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedRepeat = newValue!;
            });
          },
          items: repeatList.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
              child: Text(value),
              value: value,
            );
          }).toList()),
    );
  }

  InputFieldReuse reminder() {
    return InputFieldReuse(
        title: 'Reminder',
        hint: '$_selectedReminder  minutes',
        widget: DropdownButton(
          underline: Container(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedReminder = int.parse(newValue!);
            });
          },
          items: reminderList.map<DropdownMenuItem<String>>((value) {
            return DropdownMenuItem<String>(
                child: Text(value.toString()), value: value.toString());
          }).toList(),
        ));
  }

  Row startAndEndTIme() {
    return Row(
      children: [
        Expanded(
            child: InputFieldReuse(
          title: 'Choose Time For Tablet',
          hint: endTime,
          widget: IconButton(
            onPressed: () {
              _getTimeFromUser(false);
            },
            icon: const Icon(Icons.timer),
          ),
        )),
      ],
    );
  }

  _getTimeFromUser(bool isStartTime) async {
    final _timePicked = await _showTimePicker();
    final formatTime = _timePicked!.format(context);

    if (_timePicked == null) {
      print('time not picked');
    } else if (isStartTime) {
      setState(() {
        startTime = formatTime;
        debugPrint('start time = $startTime');
        print('timePicker $_timePicked');
      });
    } else if (!isStartTime) {
      setState(() {
        endTime = formatTime;
        setState(() {
          notificationHour = _timePicked.hour;
          notificationMinutes = _timePicked.minute;
        });
        debugPrint('end time = $endTime');
        print('hours ${_timePicked.hour}');
        print('hours ${_timePicked.minute}');
      });
    }
  }

  Future<TimeOfDay?> _showTimePicker() {
    return showTimePicker(
        context: context, initialTime: const TimeOfDay(hour: 9, minute: 10));
  }

  _iconWidget(BuildContext context) {
    return IconButton(
        onPressed: () async {
          DateTime? datePicker = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1999),
              lastDate: DateTime(2030));

          if (datePicker != null) {
            setState(() {
              _selectedDate = datePicker;
            });
          }
        },
        icon: const Icon(
          Icons.date_range,
          color: Colors.grey,
        ));
  }
}
