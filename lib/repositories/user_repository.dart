import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smart_bus/models/bank_model.dart';
import 'package:smart_bus/models/bus_model.dart';
import 'package:smart_bus/models/customer_model.dart';
import 'package:smart_bus/models/detail_history.dart';
import 'package:smart_bus/models/history_model.dart';
import 'package:smart_bus/models/trip_history_model.dart';
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
  CollectionReference driverCollection =
      FirebaseFirestore.instance.collection('drivers');
  CollectionReference busCollection =
      FirebaseFirestore.instance.collection('active');
  CollectionReference tripHistoryCollection =
      FirebaseFirestore.instance.collection('trip_history');
  CollectionReference usersTripCollection =
      FirebaseFirestore.instance.collection('users_trip');
  CollectionReference userHistoryCollection =
      FirebaseFirestore.instance.collection('history_user');
  CollectionReference costCollection =
      FirebaseFirestore.instance.collection('cost');

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

  Future<void> updateCoin({String amount}) async {
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
    return snapshot.data()['amount'].toString() ?? '0';
  }

  Future<double> getCoinCustomer({String uid}) async {
    DocumentSnapshot snapshot = await coinCollection.doc(uid).get();
    return double.parse(snapshot.data()['amount']);
  }

  Future<void> updateCoinCustomer({String amount, String uid}) async {
    return await coinCollection.doc(uid).set({'amount': amount});
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

  Future<bool> isExistedDriver({String email}) async {
    DocumentSnapshot snapshot =
        await driverCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return snapshot.exists;
  }

  Future<Customer> getCustomerByCode({String code}) async {
    QuerySnapshot snapshot =
        await userCollection.where('code', isEqualTo: code).get();
    return Customer(
      name: snapshot.docs[0].data()['full_name'] ?? '',
      code: snapshot.docs[0].data()['code'] ?? '',
      email: snapshot.docs[0].data()['email'] ?? '',
      age: snapshot.docs[0].data()['birth'] ?? '',
      uid: snapshot.docs[0].id,
    );
  }

  Future<String> getBusId() async {
    DocumentSnapshot snapshot =
        await driverCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return snapshot.data()['busId'];
  }

  Future<Bus> getBus({String busId}) async {
    DocumentSnapshot snapshot = await busCollection.doc(busId).get();
    return Bus(
      busId: snapshot.id,
      busName: snapshot.data()['busName'] ?? '',
      currentPosition: snapshot.data()['currentPosition'] ?? '',
      lsUser: List<String>.from(snapshot.data()['lsUser'] ?? []),
      lsStreet: List<String>.from(snapshot.data()['lsStreet'] ?? []),
    );
  }

  // them trip history va tra ve id cua doc
  Future<String> addTripHistory({TripHistory tripHistory}) async {
    String idTrip;
    await tripHistoryCollection.add({
      'busId': tripHistory.busId,
      'startIndex': tripHistory.startIndex,
      'endIndex': tripHistory.endIndex,
      'userId': tripHistory.userId,
      'isDone': tripHistory.isDone,
    }).then((value) {
      idTrip = value.id;
    });
    return idTrip;
  }

  Future<void> updateUserTrip(
      {String currentTripId, bool isOnBus, String userId}) async {
    return await usersTripCollection.doc(userId).set({
      'currentTripId': currentTripId,
      'isOnBus': isOnBus,
    });
  }

  Future<void> updateBusLsUser({String busId, List<String> lsUser}) async {
    return await busCollection.doc(busId).update({'lsUser': lsUser});
  }

  Future<String> getCurrentTripID({String userId}) async {
    DocumentSnapshot snapshot = await usersTripCollection.doc(userId).get();
    return snapshot.data()['currentTripId'] ?? '';
  }

  Future<void> updateTripHistory({String idTH, int endIndex}) async {
    return await tripHistoryCollection.doc(idTH).update({
      'endIndex': endIndex,
      'isDone': true,
    });
  }

  Future<List<String>> getListUserHistory({String userID}) async {
    DocumentSnapshot snapshot = await userHistoryCollection.doc(userID).get();
    print('find bugs1');
    print(snapshot.exists);
    if (snapshot.exists) {
      print('find bugs');
      return List<String>.from(snapshot.data()['lsTrip']);
    }
    return List<String>();
  }

  Future<void> addUserHistoy({String userID, List<String> lsUpdate}) async {
    return await userHistoryCollection.doc(userID).set({
      'lsTrip': lsUpdate,
    });
  }

  Future<void> updatePosition({String busId, int pos}) async {
    return await busCollection.doc(busId).update({
      'currentPosition': pos,
    });
  }

  Future<bool> isUserOnBus() async {
    DocumentSnapshot snapshot =
        await usersTripCollection.doc(this._firebaseAuth.currentUser.uid).get();
    if (!snapshot.exists) {
      return false;
    }
    if (snapshot.data()['isOnBus']) {
      return true;
    }
    return false;
  }

  Future<String> getUserCurrentTrip() async {
    DocumentSnapshot snapshot =
        await usersTripCollection.doc(this._firebaseAuth.currentUser.uid).get();
    return snapshot.data()['currentTripId'];
  }

  Future<TripHistory> getTripHistory({String tripID}) async {
    DocumentSnapshot snapshot = await tripHistoryCollection.doc(tripID).get();

    return TripHistory(
      busId: snapshot.data()['busId'],
      endIndex: snapshot.data()['endIndex'],
      isDone: snapshot.data()['isDone'],
      startIndex: snapshot.data()['startIndex'],
      userId: snapshot.data()['userId'],
    );
  }

  Future<int> getCost({String userID}) async {
    DocumentSnapshot snapshot = await costCollection.doc(userID).get();
    if (snapshot.exists) {
      return snapshot.data()['cost'];
    }
    return 0;
  }

  Future<int> getCurrrentCost() async {
    DocumentSnapshot snapshot =
        await costCollection.doc(this._firebaseAuth.currentUser.uid).get();
    if (snapshot.exists) {
      return snapshot.data()['cost'];
    }
    return 0;
  }

  Future<void> updateCost({String userID, int cost}) async {
    return await costCollection.doc(userID).set({'cost': cost});
  }

  Future<void> updateTotalCost({String tripID, int cost}) async {
    return await tripHistoryCollection.doc(tripID).update({'total': cost});
  }

  Future<List<History>> getListHistory() async {
    DocumentSnapshot snapshot = await userHistoryCollection
        .doc(this._firebaseAuth.currentUser.uid)
        .get();
    if (snapshot.exists) {
      List<String> list;
      list = List<String>.from(snapshot.data()['lsTrip'] ?? []);

      List<History> listHistory = List<History>();

      for (int i = 0; i < list.length; i++) {
        DocumentSnapshot res = await tripHistoryCollection.doc(list[i]).get();
        listHistory.add(new History(
          busId: res.data()['busId'] ?? '',
          endIndex: res.data()['endIndex'] ?? 0,
          isDone: res.data()['isDone'] ?? true,
          startIndex: res.data()['startIndex'] ?? 0,
          total: res.data()['total'] ?? 0,
        ));
      }
      return listHistory;
    }
    return List<History>();
  }
}
