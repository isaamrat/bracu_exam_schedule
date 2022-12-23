import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:summer22_final/model/exam_model.dart';

class ScheduleApi {
  static Future<List<Schedule>> getScheduleLocally(
      BuildContext context, String query) async {
    final assetBundle = DefaultAssetBundle.of(context);
    final data = await assetBundle
        .loadString('assets/obj/fall22_final.json');
    final body = json.decode(data);

    // print('***********');
    // print(body);
    // query = 'CSE110';
    // print(body);
    // List<Schedule> sclist =
    //     body.map<Schedule>(Schedule.fromJson).where((courses) {
    //   final titleLower = courses.course.toLowerCase();
    //   final searchLower = query.toLowerCase();
    //   return titleLower.contains(searchLower);
    // }).toList();
    // print(sclist.length);
    List<Schedule> sclist = body.map<Schedule>(Schedule.fromJson).toList();
    List<Schedule> newList = sclist.where((courses) {
      final upperTitle = courses.course.toUpperCase();
      final upperQuery = query.toUpperCase();

      return upperTitle.contains(upperQuery);
    }).toList();
    // List<Schedule> dateList = <Schedule>[];
    // for (var i = 0; i < newList.length; i++) {
    //   // print(newList[i].final_exam_date);
    //   dateList.add(newList[i]);
    // }
    // print('Here');
    // dateList.sort();
    // var monthIdentifier = {'January':'01','February':'02','March':'03','April':'04','May':'05','June':'06','July':'07','August':'08','September':'09','October':'10','November':'11','December':'12'};
    // for (var i = 0; i < dateList.length; i++) {
    //       List examDate = dateList[i].final_exam_date.split(' ');
    //       String ithDateStr = examDate[2]+'-'+monthIdentifier[examDate[1]]+'-'+examDate[0];
    //       // print(ithDate);
    //       DateTime ithDate = DateTime.parse(ithDateStr);
    //   for (var j = 0; j < dateList.length; i++) {
    //     List examDate = dateList[j].final_exam_date.split(' ');
    //       String jthDateStr = examDate[2]+'-'+monthIdentifier[examDate[1]]+'-'+examDate[0];
    //       // print(ithDate);
    //       DateTime jthDate = DateTime.parse(jthDateStr);
    //     if (ithDate.isAfter(jthDate)) {
    //       Schedule temp = dateList[i];
    //       dateList[i] = dateList[j];
    //       dateList[j] = temp;
    //     }
    //   }
    //   // print(dateList[i]);
    // }
    // print('end here');
    return newList;
    // return body.map<Schedule>(Schedule.fromJson).toList();
  }
}
