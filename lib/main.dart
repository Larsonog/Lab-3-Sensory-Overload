import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:overexpose_journal/camera.dart';
import 'package:overexpose_journal/journal_entry_screen.dart';
import 'package:overexpose_journal/home_screen.dart';
import 'package:sqflite/sqflite.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final cameras = await availableCameras();

  final firstCamera = cameras.first;

  databaseFactory = databaseFactory;

  runApp(OverExposeJournal(firstCamera: firstCamera));
}


class OverExposeJournal extends StatelessWidget {
  const OverExposeJournal({super.key, required this.firstCamera});

  static const String _title = 'Overexpose Journal';
  final CameraDescription firstCamera;

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
                journalEntry: args.journalEntry,
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
        return null;
      },
      title: _title,
      home:  const HomeScreen(),
    );
  }
}
