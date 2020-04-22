import 'package:ObejectOE/laguageModel.dart';
import 'package:ObejectOE/translate.dart';
import 'package:camera/camera.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:math' as math;

//import 'models.dart';
import 'rectBox.dart';
import 'widgets/loader.dart';
import 'package:flutter_picker/flutter_picker.dart';

class CameraView extends StatefulWidget {
  final List<CameraDescription> cameras;
  CameraView(this.cameras);

  @override
  _CameraViewState createState() => new _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  Size screen;

  CameraController controller;
  bool isDetecting = false;

  List<dynamic> _recognitions;
  
  /*int _imageHeight = 0;
  int _imageWidth = 0;
  String _model = mobilenet;*/
  Map<String, dynamic> rec;

  int _selectedLangauageIndex;
  FixedExtentScrollController scrollController;
  LanguageListModel languageListModel;
  Translate translator;
  static String secondaryLanguage;
  static String label = '';
  static String translated_label = '';

  @override
  void initState() {
    super.initState();

    _loadModel();
    if (_selectedLangauageIndex == null) _selectedLangauageIndex = 5;
    
    secondaryLanguage = 'bn';
    languageListModel = new LanguageListModel();
    scrollController =
        FixedExtentScrollController(initialItem: _selectedLangauageIndex);
    translator = new Translate();

    _initCamera();
    debugPrint('init');
  }

  @override
  void setState(fn) {
    super.setState(fn);
  }

  /*void _renderBoxes(var results) {
    // ssd mobilenet
    if (results.toString() == '[]') {
      // mobilenet
      label = '';
      translated_label = '';
    }
    return results.map((re) {
      var _x = re["rect"]["x"]; // ei part ta camera view e handle kore
      var _w = re["rect"]
          ["w"]; // only (x,y,w,h, label, translated_labe) ekhane pass korbo
      var _y = re["rect"]["y"];
      var _h = re["rect"]["h"];
      var scaleW, scaleH, x, y, w, h;

      if (screenH / screenW > previewH / previewW) {
        scaleW = screenH / previewH * previewW;
        scaleH = screenH;
        var difW = (scaleW - screenW) / scaleW;
        x = (_x - difW / 2) * scaleW;
        w = _w * scaleW;
        if (_x < difW / 2) w -= (difW / 2 - _x) * scaleW;
        y = _y * scaleH;
        h = _h * scaleH;
      } else {
        scaleH = screenW / previewW * previewH;
        scaleW = screenW;
        var difH = (scaleH - screenH) / scaleH;
        x = _x * scaleW;
        w = _w * scaleW;
        y = (_y - difH / 2) * scaleH;
        h = _h * scaleH;
        if (_y < difH / 2) h -= (difH / 2 - _y) * scaleH;
      }
      debugPrint(
          "${re["detectedClass"]} ${(re["confidenceInClass"] * 100).toStringAsFixed(0)}%");
      label = re["detectedClass"].toString();
      translated_label = translator.translate(label);
      return Positioned(
        left: math.max(0, x),
        top: math.max(0, y),
        width: w,
        height: h,
        child: Container(
          padding: EdgeInsets.only(top: 5.0, left: 5.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: Color.fromRGBO(37, 213, 253, 1.0),
              width: 3.0,
            ),
          ),
        ),
      );
    }).toList();
  }*/

  void _renderStrings(var results) {
    if (results.toString() == '[]') {
      label = '';
      translated_label = '';
    } else
      return results.map((re) {
        //debugPrint("${re["label"]} ${(re["confidence"] * 100).toStringAsFixed(0)}%");
        label = re["label"].toString();
        translated_label = translator.translate(label, secondaryLanguage);
      }).toList();
  }

  setRecognitions(recognitions, imageHeight, imageWidth) {
    setState(() {
      _renderStrings(recognitions);
      //debugPrint('L: ' + label + 'Tr.L: ' + translated_label);

      //_recognitions = recognitions; // for ssd only
      //_imageHeight = imageHeight; // for ssd
      //_imageWidth = imageWidth; // for ssd
    });
  }

  _loadModel() async {
    String res; // model initialize
    /*res = await Tflite.loadModel(     
        model: "assets/ssd_mobilenet.tflite",
        labels: "assets/ssd_mobilenet.txt");*/
    res = await Tflite.loadModel(
        model: "assets/mobilenet_v1_1.0_224.tflite",
        labels: "assets/mobilenet_v1_1.0_224.txt");
    //debugPrint(res);
  }

  _initCamera() {
    if (widget.cameras == null || widget.cameras.length < 1) {
      //debugPrint('No camera is found');
    } else {
      //debugPrint("Model: " + _model);

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

            /*Tflite.detectObjectOnFrame(     //ssd mobilenet / yolo
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
            });*/

            Tflite.runModelOnFrame(
                    bytesList: img.planes.map((plane) {
                      return plane.bytes;
                    }).toList(),
                    imageHeight: img.height, // mobilenet
                    imageWidth: img.width,
                    numResults: 1,
                    threshold: 0.65)
                .then((recognitions) {
              debugPrint(recognitions.toString());
              setRecognitions(recognitions, img.height, img.width);
              isDetecting = false;
            });
          }
        });
      });
    }
  }

  Widget buildCameraView(BuildContext context) {
    var screenH = math.max(screen.height, screen.width);
    var screenW = math.min(screen.height, screen.width);
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
    screen = MediaQuery.of(context).size;
    if (controller == null || !controller.value.isInitialized) {
      return Center(
        child: ColorLoader2(
          color1: Colors.red,
          color2: Colors.green,
          color3: Colors.blue,
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          buildCameraView(context),
          ResultState(
              screen.height,
              screen.width,
              label,
              translated_label),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            showPickerModal(context), //languagePickerPopUp(context),
        backgroundColor: Colors.black,
        child: Icon(
          Icons.translate,
          size: 24,
        ),
        shape: CircleBorder(),
      ),
    );
  }
  List<int> _index;
  showPickerModal(BuildContext context) {
    _index = new List<int>();
    _index.add(_selectedLangauageIndex);
    new Picker(
      selecteds: _index,
      title: Text('Language', style: TextStyle(fontSize: 22),),
      height: 200,
      itemExtent: 35,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      textAlign: TextAlign.center,
      selectedTextStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
      adapter: PickerDataAdapter<String>(
          pickerdata: languageListModel.languageList1),
      changeToFirst: false,
      hideHeader: false,
      onConfirm: (Picker picker, List index) {
        setState(() {
          _selectedLangauageIndex = index[0];
          //debugPrint('onChanged : ' + _selectedLangauageIndex.toString());
          secondaryLanguage = languageListModel.langList[_selectedLangauageIndex]['langCode'];
          //debugPrint(languageListModel.langList[_selectedLangauageIndex]['lang'] + '  ' 
          //          + languageListModel.langList[_selectedLangauageIndex]['langCode']);
        });
      },
    ).showModal(this.context); //_scaffoldKey.currentState);
  }


  @override
  void dispose() {
    controller?.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
