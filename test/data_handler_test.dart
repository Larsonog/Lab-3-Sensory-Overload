import 'package:flutter_test/flutter_test.dart';
import 'package:overexpose_journal/journal_entry.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:overexpose_journal/data_storage_handler.dart';

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
  });
  test('dhandler_save_image_test', () async {
    final DataHandler dhandler = DataHandler.instance;
    // 
  });
}