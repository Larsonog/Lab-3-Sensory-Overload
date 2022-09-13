import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

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

  
}