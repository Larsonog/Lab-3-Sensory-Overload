import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class JournalEntry {
  const JournalEntry({
    required this.path,
    required this.date,
    required this.title,
    required this.description
  });

  final String path;
  final DateTime date;
  final String title;
  final String description;

  Map<String, dynamic> toMap() {
    return {
      'date': date.toString(),
      'path': path,
      'title': title,
      'description': description
    };
  }
}