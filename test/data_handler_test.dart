import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:overexpose_journal/journal_entry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:overexpose_journal/data_storage_handler.dart';
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
  WidgetsFlutterBinding.ensureInitialized();
  test('dhandler_sql_db_test', () async {
    final DataHandler dhandler = DataHandler.instance;
    final JournalEntry entry = JournalEntry(
      path: 'test_path',
      date: DateTime.now(), 
      title: 'test_title', 
      description: 'test_description'
      );
    
    dhandler.insertEntry(entry);
    List<JournalEntry> entries = await dhandler.getAllEntries();
    
    expect(entries[0].date, entry.date);
    expect(entries[0].path, entry.path);
    expect(entries[0].title, entry.title);
    expect(entries[0].description, entry.description);

    databaseFactory.deleteDatabase(join(await databaseFactory.getDatabasesPath(), 'journal.db'));
  });
  test('dhandler_save_image_test', () async {
    final DataHandler dhandler = DataHandler.instance;
    final byteData = await rootBundle.load('assets/test_image.jpg');

    final file = File(join((await getTemporaryDirectory()).path, 'test_image.jpg'));
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

    final FileImage testImage = FileImage(file);

    final String imagePath = await dhandler.saveImage(testImage);
    final FileImage newImage = await dhandler.getImage(imagePath);

    expect(await testImage.file.readAsBytes(), await newImage.file.readAsBytes());
  });
}