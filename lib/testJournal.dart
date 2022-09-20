import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:overexpose_journal/journal_entry_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final byteData = await rootBundle.load('assets/test_image.jpg');

  final file = File(join((await getTemporaryDirectory()).path, 'test_image.jpg'));
  final String impath = file.path;
  await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
  runApp(MyApp(impath: impath));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.impath});

  final String impath;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'testJournal',
      home: JournalEntryScreen(
        path: impath
      ),
    );
  }
}