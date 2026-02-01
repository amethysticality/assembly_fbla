import 'package:flutter/material.dart';

class Event {
  final String title;
  final String category;
  final Color categoryColor;
  final String date;
  final String time;
  final String location;
  final String attendees;
  bool isRegistered;

  Event({
    required this.title,
    required this.category,
    required this.categoryColor,
    required this.date,
    required this.time,
    required this.location,
    required this.attendees,
    this.isRegistered = false,
  });
}
