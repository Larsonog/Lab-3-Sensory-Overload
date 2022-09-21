import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:overexpose_journal/camera.dart';
import 'package:overexpose_journal/journal_entry_screen.dart';
import 'package:overexpose_journal/home_screen.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  runApp(OverExposeJournal(firstCamera: firstCamera));
} //add camera: firstCamera (from camera.dart)


class OverExposeJournal extends StatelessWidget {
  const OverExposeJournal({super.key, required this.firstCamera});

  static const String _title = 'Overexpose Journal';
  final firstCamera;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) =>
            const HomeScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/entry') {
          final args = settings.arguments as JournalEntryArguments;

          return MaterialPageRoute(
            builder: (context) {
              return JournalEntryScreen(
                path: args.path,
                journal_entry: args.journal_entry,
              );
            },
          );
        } else if (settings.name == '/camera') {

          return MaterialPageRoute(
            builder: (context) {
              return TakePictureScreen(
                camera: firstCamera,
              );
            },
          );
        }
      },
      title: _title,
      home: JournalEntryScreen(
      ),
    );
  }
}
