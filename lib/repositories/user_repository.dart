import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  final FirebaseAuth _firebaseAuth;
  UserRepository({FirebaseAuth firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
    await users.where('email', isEqualTo: email).get().then((value) {
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
}
