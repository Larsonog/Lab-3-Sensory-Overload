import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
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

  
}

class JournalEntryScreen extends StatelessWidget {
  const JournalEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea (
        child: ListView(
          children: [
            Image(
              image: MemoryImage(kTransparentImage),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.done), onPressed: () {}),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}