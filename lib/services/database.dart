import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  // userid of the user
  late final String uid;

  DatabaseService({required this.uid});

  // users collection reference
  final CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');

  // creating new document for a new user and updating existing userdata
  Future updateUserData({required String name, required String email, required String password, required String bikeId, required bool isInDanger}) async {
    return await usersCollection.doc(uid).set({
      'name': name,
      'email': email,
      'password': password,
      'bikeId': bikeId,
      'isInDanger': isInDanger
    });
  }

}