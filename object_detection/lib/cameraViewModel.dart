import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/cameraView.dart';
import 'package:object_detection/models.dart';
import 'package:object_detection/rectBox.dart';
import 'dart:math' as math;
import 'package:tflite/tflite.dart';

class CameraViewModel extends StatefulWidget {
  final List<CameraDescription> cameras;
  CameraViewModel(this.cameras);
  
  @override
  _CameraViewModelState createState() => new _CameraViewModelState();
}

class _CameraViewModelState extends State<CameraViewModel> {


  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = ssd;    // mobilenet , yolo , posenet
  @override
  void initState() {
    loadModel();
    super.initState();
  }

  loadModel() async {
    String res;
    
    switch (_model) {
      case yolo:
        res = await Tflite.loadModel(
          model: "assets/yolov2_tiny.tflite",
          labels: "assets/yolov2_tiny.txt",
        );
        break;

      case mobilenet:
        res = await Tflite.loadModel(
            model: "assets/mobilenet_v1_1.0_224.tflite",
            labels: "assets/mobilenet_v1_1.0_224.txt");
        break;

      case posenet:
        res = await Tflite.loadModel(
            model: "assets/posenet_mv1_075_float_from_checkpoints.tflite");
        break;

      default:    // ssd
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }
    debugPrint(res);
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      //appBar: AppBar(),
      body: Stack(
        children: [
          CameraView(
            widget.cameras,
            _model,
            setRecognitions,
          ),
          RectBox(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model),
        ],
      ),
      /*_model == ""
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    child: const Text(ssd),
                    onPressed: () => onSelect(ssd),
                  ),
                  RaisedButton(
                    child: const Text(yolo),
                    onPressed: () => onSelect(yolo),
                  ),
                  RaisedButton(
                    child: const Text(mobilenet),
                    onPressed: () => onSelect(mobilenet),
                  ),
                  RaisedButton(
                    child: const Text(posenet),
                    onPressed: () => onSelect(posenet),
                  ),
                ],
              ),
            )
          : Stack(
              children: [
                Camera(
                  widget.cameras,
                  _model,
                  setRecognitions,
                ),
                BndBox(
                    _recognitions == null ? [] : _recognitions,
                    math.max(_imageHeight, _imageWidth),
                    math.min(_imageHeight, _imageWidth),
                    screen.height,
                    screen.width,
                    _model),
              ],
            ),*/
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
