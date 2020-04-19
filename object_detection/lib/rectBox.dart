import 'package:ObejectOE/translate.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

import 'widgets/loader.dart';
import 'package:link/link.dart';

class ResultState extends StatelessWidget {
  final List<dynamic> results;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String model;

  final Translate translator;

  ResultState(this.results, this.previewH, this.previewW, this.screenH,
      this.screenW, this.model, this.translator);

  static String label = '';
  static String translated_label = '';
  @override
  Widget build(BuildContext context) {
    List<Widget> _renderBoxes() {
      return results.map((re) {
        var _x = re["rect"]["x"];   // ei part ta camera view e handle kore
        var _w = re["rect"]["w"];   // only (x,y,w,h, label, translated_labe) ekhane pass korbo
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
    }

    return Stack(
      children: <Widget>[
        Stack(children: _renderBoxes()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
              height: screenH * 0.2,
              width: screenW * 0.75,
              margin: EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: Colors.white60,
                borderRadius: BorderRadius.all(new Radius.circular(20.0)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  AnimatedOpacity(
                    opacity: label == '' ? 1 : 0,
                    duration: Duration(milliseconds: 200),
                    child: ColorLoader5(
                      dotOneColor: Colors.red,
                      dotTwoColor: Colors.green,
                      dotThreeColor: Colors.blue,
                      dotType: DotType.circle,
                      dotIcon: Icon(Icons.adjust),
                      duration: Duration(seconds: 1),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: label == '' ? 0 : 1,
                    duration: Duration(milliseconds: 200),
                    child: Column(
                      children: <Widget>[
                        Text(
                          // english result
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        AnimatedOpacity(
                          opacity: translated_label == '' ? 0 : 1,
                          duration: Duration(milliseconds: 200),
                          child: Column(
                            children: <Widget>[
                              Text(
                                // translated result
                                translated_label,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                              Link(
                                child: Text('Powered by Yandex.Translate'),
                                url: 'http://translate.yandex.com/',
                                //onError: _showErrorSnackBar,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ],
    );
  }
}
