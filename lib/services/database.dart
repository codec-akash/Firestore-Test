import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testFireStore/models/brew.dart';
import 'package:testFireStore/models/user.dart';

class DataBaseService {
  final String uId;
  DataBaseService({this.uId});

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uId).set({
      'sugars': sugars,
      'name': name,
      'strength': strength,
    });
  }

  UserDataModel _userDataFromSnapShot(DocumentSnapshot snapshot) {
    return UserDataModel(
      uid: uId,
      name: snapshot.data()['name'],
      sugars: snapshot.data()['sugars'],
      strength: snapshot.data()['strength'],
    );
  }

  //brew List from snapshot
  List<Brew> _brewList(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.data()['name'] ?? "",
        sugars: doc.data()['sugars'] ?? "0",
        strength: doc.data()['strength'] ?? 0,
      );
    }).toList();
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map((event) => _brewList(event));
  }

  Stream<UserDataModel> get userData {
    return brewCollection
        .doc(uId)
        .snapshots()
        .map((userData) => _userDataFromSnapShot(userData));
  }
}
