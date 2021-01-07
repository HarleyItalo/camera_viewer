import 'dart:async';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(CameraApp());
}

class CameraApp extends StatefulWidget {
  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  CameraController controller;
  int currentCamera = 0;
  double scale = 1.0;
  changeCamera() {
    controller = CameraController(
      cameras[currentCamera],
      ResolutionPreset.max,
    );

    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    changeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor:
          Colors.black, // navigation bar color// status bar color
    ));
    if (!controller.value.isInitialized) {
      return Container();
    }
    return GestureDetector(
      onDoubleTap: () {
        if (currentCamera < cameras.length - 1) {
          currentCamera++;
        } else {
          currentCamera = 0;
        }
        changeCamera();
      },
      onLongPress: () {
        scale += 0.5;
        if (scale > 4) {
          scale = 1.0;
        }
        print(scale);
        setState(() {});
      },
      onTap: () {
        scale = 1.0;
        setState(() {});
      },
      child: Transform.scale(
          scale: scale,
          child: AspectRatio(
              aspectRatio: 21 / 10, child: CameraPreview(controller))),
    );
  }
}
