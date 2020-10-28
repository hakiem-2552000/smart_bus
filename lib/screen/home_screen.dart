import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_bus/screen/capture_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> addUser() async {
    // Call the user's CollectionReference to add a new user
    // return users
    //     .add({
    //       'full_name': 'Ha Vu Son Kiem', // John Doe
    //       'age': 22 // 42
    //     })
    //     .then((value) => print("User Added"))
    //     .catchError((error) => print("Failed to add user: $error"));
    // UserRepository().createUserWithEmailAndPassword(
    //   email: 'sonkiema3@gmail.com',
    //   password: 'hakiem123456@',
    // );
    // UserRepository().signOut();
    // UserRepository().getUser().then((value) {
    //   print(value.uid);
    // });
    // UserRepository().isSignIn().then((value) {
    //   print(value.toString());
    // });
    // UserRepository().signInWithEmailAndPassword(
    //     email: 'sonkiema3@gmail.com', password: 'hakiem123456@');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: FlatButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CaptureCardScreen()));
          },
          child: Text(
            "Add User",
          ),
        ),
      ),
    );
  }
}
