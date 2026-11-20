import 'package:flutter/material.dart';

/// Data model representing a single task stored in the app's in-memory state.
/// Holds the four required task properties specified in Lab 5:
/// title, multi-line description, deadline date, and display colour.
class Task {
  final String title;
  final String description;
  final DateTime deadline;
  final Color color;

  Task({
    required this.title,
    required this.description,
    required this.deadline,
    required this.color,
  });
}