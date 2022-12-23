import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../api/schedule_api.dart';
import '../model/exam_model.dart';

String firstExam = '';

class newDesktop extends StatefulWidget {
  final double maxWidth;

  const newDesktop({super.key, required this.maxWidth});

  @override
  State<newDesktop> createState() => _newDesktopState();
}

class _newDesktopState extends State<newDesktop> {
  final gridWindowDesktop getObject = Get.put(gridWindowDesktop());
  final rightCardClass rightCardObject = Get.put(rightCardClass());
  var courseCode = TextEditingController();
  String query = '';
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
                    rightCardObject.initStateChange(2);
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
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.1,
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
                        query = '';
                        courseCode.clear();
                        getObject.changeQuery(query);
                        setState(() {
                          // desktopPage();
                        });
                      },
                      icon: Icon(
                        Icons.clear_rounded,
                        color: Colors.black,
                      ),
                    )
                    // border:
                    ),
                onChanged: (courseCode) {
                  query = courseCode.toString();
                  getObject.changeQuery(query);
                  // print(serachedCourseCode);
                  setState(() {
                    // desktopPage();
                  });
                },
              ),
            ),
          ),
          (widget.maxWidth > 1400)
              ? Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 1400),
                    child: Row(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          // width: MediaQuery.of(context).size.width * 0.7,
                          width: 900,
                          child: GetBuilder<gridWindowDesktop>(
                              builder: (_) => getObject.getWindow(
                                  context, rightCardObject)),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.8,
                          // width: MediaQuery.of(context).size.width * 0.29,
                          width: 500,
                          child: GetBuilder<rightCardClass>(
                              builder: (_) =>
                                  rightCardObject.rightSide(context)),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.6,
                        // width: 900,
                        child: GetBuilder<gridWindowDesktop>(
                            builder: (_) =>
                                getObject.getWindow(context, rightCardObject)),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        width: MediaQuery.of(context).size.width * 0.39,
                        // width: 500,
                        child: GetBuilder<rightCardClass>(
                            builder: (_) => rightCardObject.rightSide(context)),
                      ),
                    ],
                  ),
                ),
          // GetBuilder<tempCheck>(builder: (_) => tempCard.boxText())
        ],
      ),
    );
  }
}

class gridWindowDesktop extends GetxController {
  bool clicked = false;
  String query = '';
  void changeQuery(String givenQuery) {
    query = givenQuery;
    update();
  }

  Widget getWindow(BuildContext context, rightCardClass rightCardObject) {
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
              return build(context, schedules!, rightCardObject);
            }
        }
      },
    );
  }

  Widget build(BuildContext context, List<Schedule> items,
      rightCardClass rightCardObject) {
    // List<Schedule> items = itemsMain[0];
    return GridView.builder(
        key: PageStorageKey<String>('scrollPos'),
        padding: EdgeInsets.all(5),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 270,
            childAspectRatio: 2,
            crossAxisSpacing: 5,
            mainAxisSpacing: 5),
        itemCount: items.length,
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
                    rightCardObject.changeValues(
                        schedule.course,
                        schedule.section,
                        schedule.final_exam_date,
                        schedule.final_exam_time,
                        schedule.room,
                        rightCardObject.todayDate(schedule.final_exam_date));
                    rightCardObject.initStateChange(1);
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
}

class rightCardClass extends GetxController {
  int initState = 0;
  String course = 'none',
      section = 'none',
      date = 'none',
      time = 'none',
      room = 'none',
      remaining = 'none';

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

  void initStateChange(int givenState) {
    initState = givenState;
    update();
  }

  Widget rightSide(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: (initState == 0)
            ? Card(
                child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
                child: GridTile(
                  header: Center(
                    child: Text(
                      'Fall22 Final Exam Schedule',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w700),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Image(
                          image: AssetImage('assets/exam_grey-bg.png'),
                          width: MediaQuery.of(context).size.height * 0.35,
                          fit: BoxFit.fitHeight,
                        ),
                        Text(
                          'Exam is coming.',
                          style: TextStyle(fontSize: 22),
                        ),
                        Text(
                          '${todayDate('24 December 2022')} days remaining.',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
            : (initState == 1)
                ? Card(
                    child: GridTile(
                      header: AppBar(
                        centerTitle: true,
                        title: Text(
                          'Exam Schedule Details',
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                        backgroundColor: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(5))),
                        elevation: 0,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  'Course: ${this.course}',
                                  style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  'Section: ${this.section}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 35,
                                ),
                                Text(
                                  'Exam Date:',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${this.date}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  'Exam Time:',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${this.time}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  'Room No:',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  '${this.room}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  '${this.remaining} days remaining',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700),
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
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade300),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('close'),
                              ),
                              onPressed: () {
                                initStateChange(0);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Card(
                    child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 15),
                    child: GridTile(
                      header: Center(
                        child: Text(
                          'BRACU Exam Schedule',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w700),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image:
                                  AssetImage('assets/Developer_activity.png'),
                              // width: MediaQuery.of(context).size.width * 0.3,
                              width: MediaQuery.of(context).size.height * 0.35,
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
                              'email: samratkhan2020@hotmail.com',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'isaamrat.github.io',
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
  }

  String todayDate(String exam_Date) {
    // String exDay = exam_Date.substring(0, 2);
    // String exDate = '2022-11-' + exDay;
    var monthIdentifier = {'January':'01','February':'02','March':'03','April':'04','May':'05','June':'06','July':'07','August':'08','September':'09','October':'10','November':'11','December':'12'};
    
    List examDate = exam_Date.split(' ');
    String ithDateStr =
        examDate[2] + '-' + monthIdentifier[examDate[1]] + '-' + examDate[0];
    String date = DateTime.now().toString();
    date = date.substring(0, 10);
    // date = '2022-10-10';

    DateTime examDayDate = DateTime.parse(ithDateStr);
    // print(examDayDate);
    DateTime todayDate = DateTime.parse(date);
    String difference = examDayDate.difference(todayDate).inDays.toString();
    if (difference.substring(0, 1) == '-') {
      return '0';
    }
    return difference;
  }
}
