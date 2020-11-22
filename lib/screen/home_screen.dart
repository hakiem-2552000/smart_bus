import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_bus/blocs/auth_bloc.dart';
import 'package:smart_bus/main.dart';
import 'package:smart_bus/repositories/user_repository.dart';
import 'package:smart_bus/screen/barcode_scanner.dart';
import 'package:smart_bus/screen/capture_card.dart';
import 'package:smart_bus/states/auth_state.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String _email = '';
  @override
  void initState() {
    super.initState();
    getEmail();
    getUid();
  }

  void getUid() async {
    userRepository.getUser().then((value) {
      print(value.uid);
    });
  }

  void getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString('email');
    setState(() {
      _email = email;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => BarcodeScanScreen()));
              },
              child: Text('Go'),
            )
          ],
        ),
      ),
    );
  }
}
