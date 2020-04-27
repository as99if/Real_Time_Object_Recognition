import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cameraView.dart';
import 'widgets/splashScreen.dart';



class SplashPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  SplashPage(this.cameras);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  bool back = false;
  @override
  void initState() {
    // TODO: implement initState
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       child: SplashScreen(
        seconds: 3,
        photoSize: 48,
        navigateAfterSeconds: CameraView(widget.cameras),
        image: Stack(
          children: <Widget>[
            Image(image: AssetImage('assets/logo_back.png'),),
            Image(image: AssetImage('assets/logo.png'),),
            
          ] 
        ), 
        loadingText: Text('Initializing ...', 
          style: GoogleFonts.ubuntuMono(
            fontSize: 20
            ),//TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
        ),
        //backgroundColor: Colors.red[600],
        gradientBackground: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
                colors: [Colors.red, Colors.red[300]],
                stops: [0.0, 0.8],
              ),
        title: new Text('ObjecToe',
          style: GoogleFonts.patrickHand(fontSize: 30), /*TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25.0
          ),*/
        ),
       ),
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}