import 'dart:io';

import 'package:edge_detection/edge_detection.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CaptureCardScreen extends StatefulWidget {
  @override
  _CaptureCardScreenState createState() => _CaptureCardScreenState();
}

class _CaptureCardScreenState extends State<CaptureCardScreen> {
  String _imagePath = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String imagePath;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      imagePath = await EdgeDetection.detectEdge;
    } on PlatformException {
      imagePath = 'Failed to get cropped image path.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
  }

  Future readText() async {
    print('oke');
    FirebaseVisionImage ourImage =
        FirebaseVisionImage.fromFile(File(_imagePath));
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          print(word.text);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: 400,
            height: 400,
            child: Image.file(new File(_imagePath)),
          ),
          Text('Path: ' + _imagePath),
          FlatButton(
              onPressed: () {
                readText();
              },
              child: Text('Read text')),
        ],
      ),
    );
  }
}
