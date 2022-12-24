// ignore_for_file: sort_child_properties_last, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../api/schedule_api.dart';
import '../model/exam_model.dart';

class testPage extends StatefulWidget {
  const testPage({super.key});

  @override
  State<testPage> createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  final gridWindow getObject = Get.put(gridWindow());
  var courseCode = TextEditingController();
  String query = '';
  int changed = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Image(
                image: AssetImage('assets/bracu_logo.png'),
                height: 75,
              ),
            ),
            centerTitle: true,
            title: Text(
              'BRACU',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => Dialog(
                              // contentPadding: EdgeInsets.all(0.0),
                              backgroundColor: Colors.transparent,
                              // title: Text('About'),
                              child: Card(
                                  child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 15),
                                child: GridTile(
                                  header: Center(
                                    child: Text(
                                      'BRACU Exam Schedule',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Image(
                                            image: AssetImage(
                                                'assets/Developer_activity.png'),
                                            // width: MediaQuery.of(context).size.width * 0.3,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.4,
                                          ),
                                          SizedBox(
                                            height: 50,
                                          ),
                                          Text(
                                            'Developed by',
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          Text(
                                            'Khalid Khan Samrat',
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          Text(
                                            'Email: samratkhan2020@hotmail.com',
                                            style: TextStyle(fontSize: 22),
                                          ),
                                          Text(
                                            'isaamrat.github.io',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  footer: Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 15.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.grey.shade300),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('close'),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                            ));
                  },
                  icon: Icon(Icons.info_outline)),
              SizedBox(
                width: 8,
              )
            ],
            backgroundColor: Colors.white,
            elevation: 0.5,
            toolbarHeight: 65,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.94,
            // height: MediaQuery.of(context).size.height * 0.1,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 6.0, horizontal: 2),
              child: Center(
                child: Text(
                  'Fall22 Final Exam Schedule',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.grey.shade800),
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.94,
            // height: MediaQuery.of(context).size.height * 0.1,
            child: Center(
              child: TextField(
                controller: courseCode,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    hintText: 'Ex. CSE110',
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // SystemChannels.textInput.invokeMethod('TextInput.hide');
                        // FocusScope.of(context).unfocus();
                        // FocusScopeNode currentFocus = FocusScope.of(context);
                        // if (!currentFocus.hasPrimaryFocus) {
                        //   currentFocus.focusedChild!.unfocus();
                        // }
                        query = '';
                        courseCode.clear();
                        getObject.queryChange('');
                        // dupRight.changeClick();
                        getObject.changeToPreviousKey();
                        
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.black,
                      ),
                    )
                    // border:
                    ),
                onChanged: (courseCode) {
                  // FocusScope.of(context).isFirstFocus;
                  // FocusScope.of(context).focusedChild;
                  query = courseCode.toString();
                  changed++;
                  getObject.changeKey(changed.toString());
                  getObject.queryChange(query);
                  // dupRight.changeQuery(query);
                  // print(serachedCourseCode);
                },
              ),
            ),
          ),
          Expanded(
            child: GetBuilder<gridWindow>(
                builder: (_) => getObject.getWindow(context)),
          ),
        ],
      ),
    );
  }
}

class gridWindow extends GetxController {
  bool clicked = false;
  PageStorageKey pageKey = PageStorageKey('new');
  PageStorageKey tempHoldKey = PageStorageKey('new');

  String course = 'none',
      section = 'none',
      date = 'none',
      time = 'none',
      room = 'none',
      remaining = 'none',
      query = '';

  void queryChange(String givenQuery) {
    query = givenQuery;
    update();
  }

  void changeKey(String val) {
    pageKey = PageStorageKey(val);
    update();
  }

  void changeToPreviousKey() {
    pageKey = tempHoldKey;
    update();
  }

  void changeClicked(bool status) {
    clicked = status;
    update();
  }

  void changeValues(String givenCourse, givenSection, givenDate, givenTime,
      givenRoom, givenRemaining) {
    course = givenCourse;
    section = givenSection;
    date = givenDate;
    time = givenTime;
    room = givenRoom;
    remaining = givenRemaining;
    update();
  }

  Widget getWindow(BuildContext context) {
    if (!clicked) {
      return FutureBuilder<List<Schedule>>(
        future: ScheduleApi.getScheduleLocally(context, query),
        builder: (context, snapshot) {
          final schedules = snapshot.data;
          // print(snapshot.data);
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            default:
              if (snapshot.hasError) {
                return Center(
                  child: Text('Some error occured ! '),
                );
              } else {
                return build(context, schedules!);
              }
          }
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          child: GridTile(
            // header: AppBar(
            //   centerTitle: true,
            //   title: Text(
            //     'Details',
            //     style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
            //   ),
            //   backgroundColor: Colors.grey.shade200,
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.vertical(top: Radius.circular(5))),
            //   elevation: 0,
            // ),
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        // color: Colors.grey.shade300,
                        decoration: BoxDecoration(  
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5)
                        ),
                        width: double.infinity,
                        // ignore: prefer_const_constructors
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Details',
                              style: TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Course: ${this.course}',
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Section: ${this.section}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Text(
                        'Exam Date:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${this.date}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Exam Time:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${this.time}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Text(
                        'Room No:',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${this.room}',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        '${this.remaining} days remaining',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('close'),
                        ),
                        onPressed: () {
                          changeClicked(false);
                          // FocusScope.of(context).unfocus();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            footer: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ElevatedButton(
                  //   style: ElevatedButton.styleFrom(
                  //       backgroundColor: Colors.grey.shade300),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Text('close'),
                  //   ),
                  //   onPressed: () {
                  //     changeClicked(false);
                  //     // FocusScope.of(context).unfocus();
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget build(BuildContext context, List<Schedule> items) {
    // List<Schedule> items = itemsMain[0];
    return GridView.builder(
        padding: EdgeInsets.all(5),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 320,
            childAspectRatio: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount: items.length,
        key: pageKey,
        itemBuilder: ((context, index) {
          final schedule = items[index];
          return GridTile(
              footer: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Spacer(),
                    Icon(Icons.info_outline),
                  ],
                ),
              ),
              child: Card(
                child: InkWell(
                  borderRadius: BorderRadius.circular(5),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    changeValues(
                        schedule.course,
                        schedule.section,
                        schedule.final_exam_date,
                        schedule.final_exam_time,
                        schedule.room,
                        todayDate(schedule.final_exam_date));
                    changeClicked(true);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(schedule.course,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600)),
                          Text('Section: ${schedule.section}'),
                          Text(
                              'Date: ${schedule.final_exam_date.substring(0, schedule.final_exam_date.length - 10)}'),
                          // )
                        ]),
                  ),
                ),
              ));
        }));
  }

  String todayDate(String exam_Date) {
    // String exDay = examDate.substring(0, 2);
    // String exDate = '2022-11-' + exDay;

    var monthIdentifier = {'January':'01','February':'02','March':'03','April':'04','May':'05','June':'06','July':'07','August':'08','September':'09','October':'10','November':'11','December':'12'};
    
    List examDate = exam_Date.split(' ');
    String ithDateStr =
        examDate[2] + '-' + monthIdentifier[examDate[1]] + '-' + examDate[0];
    String date = DateTime.now().toString();
    date = date.substring(0, 10);
    // print(exDate);
    // print(date);
    // date = '2022-10-10';
    DateTime examDayDate = DateTime.parse(ithDateStr);
    DateTime todayDate = DateTime.parse(date);
    String difference = examDayDate.difference(todayDate).inDays.toString();
    if (difference.substring(0, 1) == '-') {
      return '0';
    }
    return difference;
  }
}
