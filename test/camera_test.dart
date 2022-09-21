import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:camera/camera.dart';
import 'package:overexpose_journal/camera.dart';
import 'package:mockito/mockito.dart';
import 'package:overexpose_journal/journal_entry_screen.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets('Take Picture Screen has image displayed', (tester) async {
    await tester.runAsync(() async {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      await tester.pumpWidget(
          MaterialApp(home: TakePictureScreen(camera: firstCamera)));

      expect(find.byType(CameraPreview), findsOneWidget);
    });
  });

  testWidgets('Take picture button appears on screen', (tester) async {
    await tester.runAsync(() async {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      await tester.pumpWidget(
          MaterialApp(home: TakePictureScreen(camera: firstCamera)));
      final takePictureButton = find.byType(FloatingActionButton);
      expect(takePictureButton, findsOneWidget);
    });
  });

//https://stackoverflow.com/questions/50704647/how-to-test-navigation-via-navigator-in-flutter
  testWidgets('Take picture button goes to journal entry screen',
      (WidgetTester tester) async {
    await tester.runAsync(() async {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(TakePictureScreen(camera: firstCamera));

      final takePictureButton = find.byType(FloatingActionButton);
      expect(takePictureButton, findsOneWidget);
      await tester.tap(takePictureButton);
      await tester.pumpAndSettle();

      expect(find.byType(JournalEntryScreen), findsOneWidget);
    });
  });
}
