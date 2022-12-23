import 'package:flutter/material.dart';

class Schedule {
  final String sl;
  final String course;
  final String section;
  final String final_exam_time;
  final String final_exam_date;
  final String room;

  const Schedule(
      {required this.sl,
      required this.course,
      required this.section,
      required this.final_exam_time,
      required this.final_exam_date,
      required this.room});

  static Schedule fromJson(json) {

    return Schedule(
        sl: json['sl'].toString(),
        course: json['course'],
        section: json['section'].toString(),
        final_exam_time: json['final_exam_time'],
        final_exam_date: json['final_exam_date'],
        room: json['room']);
  }
}
