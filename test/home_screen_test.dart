import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:overexpose_journal/home_screen.dart';
import 'package:overexpose_journal/journal_entry.dart';

Future main() async {
  testWidgets('sortWeek_sorts_weeks', (tester) async {
    List<JournalEntry> entries = [];
    DateTime date = DateTime.utc(2020,1,5);
    for (int i = 0; i < 56; i++) {
      entries.add(JournalEntry(path: 'test', date: date, title: 'test', description: 'test'));
      date = date.add(const Duration(hours: 12));
    }
    List<List<JournalEntry>> sortedEntries = sortWeek(entries);
    expect(sortedEntries.length, 4);
    for (int i = 0; i < 4; i++) {
      expect(sortedEntries[i].length, 14);
      expect(sortedEntries[i][0].date.weekday, 7);
    }
  });
}