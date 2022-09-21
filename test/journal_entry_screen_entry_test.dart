import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:overexpose_journal/journal_entry.dart';
import 'package:overexpose_journal/journal_entry_screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

// Info on testing sqflite https://github.com/tekartik/sqflite/blob/master/sqflite/doc/testing.md

/// Initialize sqflite for test.
void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

Future main() async {
  sqfliteTestInit();
  testWidgets('journal_entry_screen_has_image', (tester) async {
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('assets/test_image.jpg');

      final file = File(join((await getTemporaryDirectory()).path, 'test_image.jpg'));
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final JournalEntry jEntry = JournalEntry(
        path: file.path, 
        date: DateTime.now(), 
        title: 'test', 
        description: 'test');
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JournalEntryScreen(journalEntry: jEntry)
      )));

      final imageFinder = find.byKey(const Key('I'));

      expect(imageFinder, findsOneWidget);
    });
  });
  testWidgets('journal_entry_screen_has_date', (tester) async {
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('assets/test_image.jpg');

      final file = File(join((await getTemporaryDirectory()).path, 'test_image.jpg'));
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final JournalEntry jEntry = JournalEntry(
        path: file.path, 
        date: DateTime.now(), 
        title: 'test', 
        description: 'test');
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JournalEntryScreen(journalEntry: jEntry)
      )));

      final dateFinder = find.text('${DateTime.now().month} / ${DateTime.now().day} / ${DateTime.now().year}');

      expect(dateFinder, findsOneWidget);
    });
  });
  testWidgets('journal_entry_screen_has_text', (tester) async {
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('assets/test_image.jpg');

      final file = File(join((await getTemporaryDirectory()).path, 'test_image.jpg'));
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      final JournalEntry jEntry = JournalEntry(
        path: file.path, 
        date: DateTime.now(), 
        title: 'testTitle', 
        description: 'testDescription');
      
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JournalEntryScreen(journalEntry: jEntry)
      )));

      final textFinder1 = find.text(jEntry.title);
      final textFinder2 = find.text(jEntry.description);

      expect(textFinder1, findsOneWidget);
      expect(textFinder2, findsOneWidget);
    });
  });
}