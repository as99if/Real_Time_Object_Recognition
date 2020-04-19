import 'package:ObejectOE/translate.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

import 'models.dart';
import 'rectBox.dart';
import 'widgets/loader.dart';

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
  Map<String, dynamic> rec;
  int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = ssd;
  Translate translator;

  static String secondaryLanguage = "en-bn";

  @override
  void initState() {
    super.initState();
    translator = Translate(lang: secondaryLanguage);
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
            isDetecting = true;

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
              setRecognitions(recognitions, img.height, img.width);
              isDetecting = false;
            });
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

    return OverflowBox(
      maxHeight:
          screenRatio > previewRatio ? screenH : screenW / previewW * previewH,
      maxWidth:
          screenRatio > previewRatio ? screenH / previewH * previewW : screenW,
      child: CameraPreview(controller),
    );
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
      body: Stack(
        children: [
          buildCameraView(context),
          ResultState(
            _recognitions == null ? [] : _recognitions,
            math.max(_imageHeight, _imageWidth),
            math.min(_imageHeight, _imageWidth),
            screen.height,
            screen.width,
            _model,
            translator,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => languagePickerPopUp(), //languagePickerPopUp(context),
        backgroundColor: Colors.black,
        child: Icon(
          Icons.translate,
          size: 24,
        ),
        shape: CircleBorder(),
      ),
    );
  }

  List<Text> languageList = [
    Text('Bengali'),
    Text('Latin'),
    Text('Japanese'),
    Text('Spanish'),
  ];
  static int _selectedLangauageIndex = 0;
  FixedExtentScrollController scrollController =
      FixedExtentScrollController(initialItem: _selectedLangauageIndex);

  Future<void> languagePickerPopUp() async {
    return showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) {
        return Row(
          children: <Widget>[
            Container(
              height: 350,
              width: MediaQuery.of(context).size.width,
              child: CupertinoPicker(
                itemExtent: 25,
                onSelectedItemChanged: (int index) {
                  _selectedLangauageIndex = index;
                },
                children: languageList,
                scrollController: scrollController,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
