import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_bus/models/bank_model.dart';
import 'package:smart_bus/models/user_infor_model.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  CollectionReference coinCollection =
      FirebaseFirestore.instance.collection('coins');
  CollectionReference bankCollection =
      FirebaseFirestore.instance.collection('bank');

  Future<void> signInWithEmailAndPassword(
      {String email, String password}) async {
    return await this._firebaseAuth.signInWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
  }

  Future<void> createUserWithEmailAndPassword(
      {String email, String password}) async {
    return await this._firebaseAuth.createUserWithEmailAndPassword(
          email: email.trim(),
          password: password,
        );
  }

  Future<void> signOut() async {
    return Future.wait([_firebaseAuth.signOut()]);
  }

  Future<bool> isSignIn() async {
    return this._firebaseAuth.currentUser != null;
  }

  Future<User> getUser() async {
    return this._firebaseAuth.currentUser;
  }

  Future<bool> isExistedUser({String email}) async {
    bool isExisted = false;
    await userCollection.where('email', isEqualTo: email).get().then((value) {
      if (value.size == 0) {
        print('EMPTY');
        isExisted = false;
      } else {
        print('Existed user');
        isExisted = true;
      }
    });
    return isExisted;
  }

  Future<bool> isExistedCode({String code}) async {
    bool isExisted = false;
    await userCollection.where('code', isEqualTo: code).get().then((value) {
      if (value.size == 0) {
        print('EMPTY');
        isExisted = false;
      } else {
        print('Existed user');
        isExisted = true;
      }
    });
    return isExisted;
  }

  Future<void> updateUserData(
      {String name, String age, String email, String code}) async {
    return await userCollection.doc(this._firebaseAuth.currentUser.uid).set({
      'full_name': name,
      'birth': age,
      'email': email,
      'code': code,
    });
  }

  Future<void> updateCoin({int amount}) async {
    return await coinCollection
        .doc(this._firebaseAuth.currentUser.uid)
        .set({'amount': amount});
  }

  Future<bool> isExistCoin() async {
    DocumentSnapshot snapshot =
        await coinCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return snapshot.exists;
  }

  Future<String> getCoin() async {
    DocumentSnapshot snapshot =
        await coinCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return snapshot.data()['amount'] ?? '0';
  }

  Future<bool> isExistBank() async {
    DocumentSnapshot snapshot =
        await bankCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return snapshot.exists;
  }

  Future<void> updateBank(
      {String cardNumber,
      String cardHolderName,
      String expiryDate,
      String cvv}) async {
    return await bankCollection.doc(this._firebaseAuth.currentUser.uid).set({
      'cardNumber': cardNumber,
      'cardHolderName': cardHolderName,
      'expiryDate': expiryDate,
      'cvv': cvv,
    });
  }

  Future<Bank> getInforBank() async {
    DocumentSnapshot snapshot =
        await bankCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return Bank(
      cardNumber: snapshot.data()['cardNumber'] ?? '',
      cardHolderName: snapshot.data()['cardHolderName'] ?? '',
      dateExpiry: snapshot.data()['expiryDate'] ?? '',
      cvv: snapshot.data()['cvv'] ?? '',
    );
  }

  Future<UserInfor> fetchUserInfor() async {
    DocumentSnapshot snapshot =
        await userCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return UserInfor(
      name: snapshot.data()['full_name'] ?? '',
      code: snapshot.data()['code'] ?? '',
      email: snapshot.data()['email'] ?? '',
      age: snapshot.data()['birth'] ?? '',
    );
  }
}
