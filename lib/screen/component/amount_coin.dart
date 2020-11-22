import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserCoin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    CollectionReference coin = FirebaseFirestore.instance.collection('coins');

    return StreamBuilder<QuerySnapshot>(
      stream: coin.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }
        DocumentSnapshot snap = snapshot.data.docs[0];
        return Text(
          snap.data()['amount'].toString() + '\$' ?? '0' + '\$',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}
