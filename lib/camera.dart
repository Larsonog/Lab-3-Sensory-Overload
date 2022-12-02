import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:overexpose_journal/journal_entry_screen.dart';
import 'package:overexpose_journal/main.dart';

class TakePictureScreen extends StatefulWidget {
  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController? _controller;
  //late Future<void> _initializeControllFuture;
  bool _initializeControllFuture = false;

  @override
  void initState() {
    onNewCameraSelected(availcameras[
        0]); // 0 is the back camera, 1 is the front camera, we start with back by default
    super.initState();
  }

  // https://blog.logrocket.com/flutter-camera-plugin-deep-dive-with-examples/#flip-camera-toggle
  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = _controller;
    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _initializeControllFuture = _controller!.value.isInitialized;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool _isRearCameraSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture of your activity')),
      body: _initializeControllFuture
          ? AspectRatio(
              aspectRatio: 2 /
                  _controller!.value
                      .aspectRatio, // issue with aspect ratio is somewhere here
              child: ClipRect(
                //camera preview and actual picture taken not the same
                child: Transform.scale(
                  alignment: Alignment.center,
                  scale: _controller!.value.aspectRatio / 0.7,
                  child: Center(
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),
            )
          : Container(),
      floatingActionButton: Row(
        // this row contains the camera icon and flip icon
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              try {
                _initializeControllFuture;
                final image = await _controller!.takePicture();
                if (!mounted) return;

                Navigator.pushNamed(context, '/entry',
                    arguments: JournalEntryArguments(path: image.path));
              } catch (e) {
                print(e);
              }
            },
            child: const Icon(Icons.camera_alt),
          ),
          CircularProgressIndicator(),
          InkWell(
            onTap: () {
              setState(() {
                _initializeControllFuture = false;
              });
              onNewCameraSelected(
                availcameras[_isRearCameraSelected ? 0 : 1],
              );
              setState(() {
                _isRearCameraSelected = !_isRearCameraSelected;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(
                  Icons.circle,
                  color: Colors.black38,
                  size: 60,
                ),
                Icon(
                    _isRearCameraSelected // if on back camera, show front camera icon to indicate flip, vice versa
                        ? Icons.camera_front
                        : Icons.camera_rear,
                    color: Colors.white,
                    size: 30),
              ],
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
