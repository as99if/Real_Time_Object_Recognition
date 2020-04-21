
import 'package:ObejectOE/translate.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'cameraView.dart';


List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    print('Error: $e.code\nError Message: $e.message');
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detections',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: CameraView(cameras),
    );
  }
}

