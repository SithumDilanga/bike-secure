import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  // userid of the user
  final String uid;

  DatabaseService({this.uid});

  // users collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // creating new document for a new user and updating existing userdata
  Future updateUserData({ String name,  String email,  String password,  String bikeId,  bool isInDanger}) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
      'bikeId': bikeId,
      'isInDanger': isInDanger
    });
  }

}