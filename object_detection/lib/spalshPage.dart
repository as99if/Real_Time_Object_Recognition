import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'cameraView.dart';
import 'widgets/splashScreen.dart';


class SplashPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  SplashPage(this.cameras);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
       child: SplashScreen(
        seconds: 3,
        photoSize: 48,
        navigateAfterSeconds: CameraView(widget.cameras),
        image: Image(image: AssetImage('assets/logo.png'), width: 300, height: 300,), 
        loadingText: Text('Initializing ...', 
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        backgroundColor: Colors.red[600],
        /*gradientBackground: LinearGradient(
          colors: [Colors.redAccent, Colors.red], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight
        ),*/
        title: new Text('ObjectOe',
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0
          ),
        ),
       ),
    );
  }
}