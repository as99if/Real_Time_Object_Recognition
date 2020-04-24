
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'cameraView.dart';
import 'spalshPage.dart';


List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    debugPrint('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detections',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashPage(cameras),
    );
  }
}

