import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:overexpose_journal/camera.dart';
import 'package:overexpose_journal/journal_entry_screen.dart';
import 'package:overexpose_journal/home_screen.dart';


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
      home: JournalEntryScreen(),
    );
  }
}

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController controller = PageController();
    return PageView(
      /// [PageView.scrollDirection] defaults to [Axis.horizontal].
      /// Use [Axis.vertical] to scroll vertically.
      controller: controller,
      children: const <Widget>[
        Center(
          child: Text('First Page'),
        ),
        Center(
          child: Text('Second Page'),
        ),
        Center(
          child: Text('Third Page'),
        ),
      ],
    );
  }
}
