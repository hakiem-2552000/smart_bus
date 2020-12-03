import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edge_detection/edge_detection.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';

import 'package:smart_bus/blocs/login_bloc.dart';
import 'package:smart_bus/events/auth_event.dart';
import 'package:smart_bus/events/login_event.dart';
import 'package:smart_bus/repositories/user_repository.dart';

import 'package:smart_bus/screen/login_screen.dart';

class CaptureCardScreen extends StatefulWidget {
  final String email;
  CaptureCardScreen({@required this.email});
  @override
  _CaptureCardScreenState createState() => _CaptureCardScreenState();
}

class _CaptureCardScreenState extends State<CaptureCardScreen> {
  String _imagePath = '';
  String result = '';
  List<String> listResult = List<String>();
  String name = '';
  String age = '';
  String code = '';
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  LoginBloc _loginBloc;
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    _authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);
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

    if (!mounted) return;

    setState(() {
      _imagePath = imagePath;
    });
    readText();
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    if (s.length <= 8) return false;
    return double.tryParse(s) != null;
  }

  Future readText() async {
    FirebaseVisionImage ourImage =
        FirebaseVisionImage.fromFile(File(_imagePath));
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    for (TextBlock block in readText.blocks) {
      for (TextLine line in block.lines) {
        for (TextElement word in line.elements) {
          result += word.text + ' ';
          if (result.contains('Họ tên') ||
              result.contains('Ho tên') ||
              result.contains('Ho ten') ||
              result.contains('tên')) {
            name = result;
          }
          if (result.contains('Ngày sinh') || result.contains('Ngay sinh')) {
            age = result;
          }
          if (isNumeric(result)) {
            setState(() {
              code = result;
            });
          }
          print(result);
        }

        result = '';
      }
    }
    if (name.indexOf(':') != -1) {
      String newName = '';
      for (int i = name.indexOf(':') + 1; i < name.length; i++) {
        newName += name[i];
      }
      setState(() {
        name = newName;
      });
    }
    if (age.indexOf(':') != -1) {
      String newAge = '';
      for (int i = age.indexOf(':') + 1; i < age.length; i++) {
        newAge += age[i];
      }
      setState(() {
        age = newAge;
      });
    }
  }

  Future readBarcode() async {
    FirebaseVisionImage ourImage =
        FirebaseVisionImage.fromFile(File(_imagePath));

    BarcodeDetector barcodeDetector = FirebaseVision.instance.barcodeDetector();
    final List<Barcode> barcodes =
        await barcodeDetector.detectInImage(ourImage);

    for (Barcode barcode in barcodes) {
      final String rawValue = barcode.rawValue;

      setState(() {
        code = rawValue;
      });
    }
  }

  Future<void> addUser() async {
    if (code.isNotEmpty) {
      return await UserRepository()
          .updateUserData(
        email: widget.email.trim(),
        code: code.trim(),
        name: name.trim(),
        age: age.trim(),
      )
          .then((value) {
        print("User Added");
        _loginBloc.add(LoginEventStarted());
        _authenticationBloc.add(AuthenticationEventStarted());
      }).catchError((error) => print("Failed to add user: $error"));
    } else {
      _buildAlert(message: 'Error', desc: 'Code is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(
          color: Colors.black,
        ),
        actions: [
          IconButton(
              icon: Icon(
                Icons.check,
                color: Colors.blue,
              ),
              onPressed: () {
                addUser();
              }),
        ],
        title: Text(
          'Information',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: _imagePath != ''
                      ? Image.file(
                          File(_imagePath),
                          fit: BoxFit.fill,
                        )
                      : SizedBox()),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  initPlatformState();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Recapture',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              _buildInforTab(title: 'Code', content: code),
              SizedBox(
                height: 10,
              ),
              _buildInforTab(title: 'Fullname', content: name),
              SizedBox(
                height: 10,
              ),
              _buildInforTab(title: 'Email', content: widget.email),
              SizedBox(
                height: 10,
              ),
              _buildInforTab(title: 'Date of birth', content: age),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      )),
    );
  }

  _buildInforTab({String title, String content}) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            title + ':',
            style: TextStyle(
              color: Colors.blue[900],
              fontWeight: FontWeight.w400,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        SizedBox(
          height: 5,
        ),
        Container(
          width: double.maxFinite,
          height: 50,
          padding: EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(content),
          ),
        ),
      ],
    );
  }

  _buildAlert({String message, String desc}) {
    Alert(
      context: context,
      type: AlertType.error,
      title: message,
      desc: desc,
      buttons: [
        DialogButton(
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }
}
