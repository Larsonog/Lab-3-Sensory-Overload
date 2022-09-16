import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:overexpose_journal/journal_entry.dart';

class JournalEntryScreen extends StatefulWidget {
  const JournalEntryScreen({super.key, this.journal_entry, this.path});

  final JournalEntry? journal_entry;
  final String? path;

  @override
  State<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends State<JournalEntryScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea (
        child: ListView(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 230),
              child: Image(
                image: MemoryImage(kTransparentImage),
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
            Text(
              '${DateTime.now().month} / ${DateTime.now().day} / ${DateTime.now().year}',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),

          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            IconButton(icon: const Icon(Icons.done), onPressed: () {
              var pass_on;

              if (widget.journal_entry == null) {
                var pass_on = JournalEntry(
                  path: widget.path!,
                  date: DateTime.now(),
                  title: '[placeholder]',
                  description: '[placeholder]'
                );
              } else {
                var pass_on = widget.journal_entry;
              }
            }),
            const Spacer(),
            IconButton(icon: const Icon(Icons.close), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}