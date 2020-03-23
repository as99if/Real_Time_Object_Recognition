import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:object_detection/models.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

typedef void Callback(List<dynamic> list, int h, int w);

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Callback setRecognitions;
  final String model;

  CameraView(this.cameras, this.model, this.setRecognitions);

  //CameraView(this._cameraController);
  @override
  _CameraViewState createState() => new _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  CameraController controller;
  bool isDetecting = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  _initCamera() {
    if (widget.cameras == null || widget.cameras.length < 1) {
      debugPrint('No camera is found');
    } else {
      debugPrint("Model: " + widget.model);

      controller = new CameraController(
        widget.cameras[0],
        ResolutionPreset.high,
        enableAudio: false
      );
      
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

            int startTime = new DateTime.now().millisecondsSinceEpoch;

            if (widget.model == 'mobilenet') {
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
              Tflite.detectObjectOnFrame(
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
            }
          }
        });
      });
    }
  }

  

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(),
        ),
      );
    }

    var tmp = MediaQuery.of(context).size;
    var screenH = math.max(tmp.height, tmp.width);
    var screenW = math.min(tmp.height, tmp.width);
    tmp = controller.value.previewSize;
    var previewH = math.max(tmp.height, tmp.width);
    var previewW = math.min(tmp.height, tmp.width);
    var screenRatio = screenH / screenW;
    var previewRatio = previewH / previewW;

    return /*SafeArea(
        child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller))
        */
        OverflowBox(
          maxHeight:
              screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
          maxWidth:
              screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
          child: CameraPreview(controller),
        );
    //);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
