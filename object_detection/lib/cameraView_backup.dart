import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'widgets/loader.dart';
import 'models.dart';
import 'rectBox.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraView(this.cameras);

  @override
  _CameraViewState createState() => new _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController controller;
  bool isDetecting = false;

  List<dynamic> _recognitions;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = ssd;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _initCamera();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _recognitions = recognitions;
      _imageHeight = imageHeight;
      _imageWidth = imageWidth;
    });
  }

  _loadModel() async {
    String res;
    res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    /*switch (_model) {
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

      default: // ssd
        res = await Tflite.loadModel(
            model: "assets/ssd_mobilenet.tflite",
            labels: "assets/ssd_mobilenet.txt");
    }*/
    debugPrint(res);
  }

  _initCamera() {
    if (widget.cameras == null || widget.cameras.length < 1) {
      debugPrint('No camera is found');
    } else {
      debugPrint("Model: " + _model);

      controller = new CameraController(
          widget.cameras[0], ResolutionPreset.high,
          enableAudio: false);

      controller.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {});

        controller.startImageStream((CameraImage img) {
          if (!isDetecting) {
            //sleep(Duration(milliseconds: 1500));
            //widget.setRecognitions([], 0, 0);
            isDetecting = true;
            //int startTime = new DateTime.now().millisecondsSinceEpoch;

            Tflite.detectObjectOnFrame(
              // default
              bytesList: img.planes.map((plane) {
                return plane.bytes;
              }).toList(),
              model: "SSDMobileNet",
              imageHeight: img.height,
              imageWidth: img.width,
              imageMean: 127.5,
              imageStd: 127.5,
              numResultsPerClass: 1,
              threshold: 0.7, //widget.model == yolo ? 0.2 : 0.4,
            ).then((recognitions) {
              //int endTime = new DateTime.now().millisecondsSinceEpoch;
              //debugPrint("Detection took ${endTime - startTime}");
              setRecognitions(recognitions, img.height, img.width);
              isDetecting = false;
            });
            /*if (widget.model == 'mobilenet') {
              Tflite.runModelOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = new DateTime.now().millisecondsSinceEpoch;
                print("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width);

                isDetecting = false;
              });
            } else if (widget.model == 'posenet') {
              Tflite.runPoseNetOnFrame(
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                imageHeight: img.height,
                imageWidth: img.width,
                numResults: 2,
              ).then((recognitions) {
                int endTime = new DateTime.now().millisecondsSinceEpoch;
                print("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width);

                isDetecting = false;
              });
            } else {    
              Tflite.detectObjectOnFrame(   // default
                bytesList: img.planes.map((plane) {
                  return plane.bytes;
                }).toList(),
                model: widget.model == yolo ? "YOLO" : "SSDMobileNet",
                imageHeight: img.height,
                imageWidth: img.width,
                imageMean: widget.model == yolo ? 0 : 127.5,
                imageStd: widget.model == yolo ? 255.0 : 127.5,
                numResultsPerClass: 1,
                threshold: 0.55, //widget.model == yolo ? 0.2 : 0.4,
              ).then((recognitions) {
                int endTime = new DateTime.now().millisecondsSinceEpoch;
                debugPrint("Detection took ${endTime - startTime}");

                widget.setRecognitions(recognitions, img.height, img.width);

                isDetecting = false;
              });
            }*/
          }
        });
      });
    }
  }

  Widget buildCameraView(BuildContext context) {
    

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    var previewSize = controller.value.previewSize;
    var previewH = math.max(previewSize.height, previewSize.width);
    var previewW = math.min(previewSize.height, previewSize.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return /*SafeArea(
        child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller))
        */
        OverflowBox(
      /*eight: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.7, */
      maxHeight: //MediaQuery.of(context).size.height * 0.,
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth: //MediaQuery.of(context).size.width * 0.7,
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
    //);
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: ColorLoader2(
          color1: Colors.red,
          color2: Colors.green,
          color3: Colors.blue,
        ),
      );
    }
    Size screen = MediaQuery.of(context).size;
    return Scaffold(
      //appBar: AppBar(),
      body: Stack(
        children: [
          buildCameraView(context),
          ResultState(
              _recognitions == null ? [] : _recognitions,
              math.max(_imageHeight, _imageWidth),
              math.min(_imageHeight, _imageWidth),
              screen.height,
              screen.width,
              _model),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
