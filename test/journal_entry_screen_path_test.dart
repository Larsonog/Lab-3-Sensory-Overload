import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show rootBundle;

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

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JournalEntryScreen(path: file.path)
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

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JournalEntryScreen(path: file.path)
      )));

      final dateFinder = find.text('${DateTime.now().month} / ${DateTime.now().day} / ${DateTime.now().year}');

      expect(dateFinder, findsOneWidget);
    });
  });
  testWidgets('journal_entry_screen_has_textFormFields', (tester) async {
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('assets/test_image.jpg');

      final file = File(join((await getTemporaryDirectory()).path, 'test_image.jpg'));
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JournalEntryScreen(path: file.path)
      )));

      final textFinder = find.byType(TextFormField);

      expect(textFinder, findsNWidgets(2));
    });
  });
  testWidgets('clicking_ok_without_typing_does_not_work', (tester) async {
    await tester.runAsync(() async {
      final byteData = await rootBundle.load('assets/test_image.jpg');

      final file = File(join((await getTemporaryDirectory()).path, 'test_image.jpg'));
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: JournalEntryScreen(path: file.path)
      )));

      await tester.tap(find.byKey(const Key('BY')));
      await tester.pump();

      final pageFinder = find.byType(JournalEntryScreen);

      expect(pageFinder, findsOneWidget);

      await tester.enterText(find.byKey(const Key('FT')), 'test');
      await tester.pump();
      await tester.tap(find.byKey(const Key('BY')));
      await tester.pump();

      expect(pageFinder, findsOneWidget);

      await tester.enterText(find.byKey(const Key('FT')), '');
      await tester.pump();
      await tester.enterText(find.byKey(const Key('FD')), 'test');
      await tester.pump();
      await tester.tap(find.byKey(const Key('BY')));
      await tester.pump();

      expect(pageFinder, findsOneWidget);
    });
  });
}