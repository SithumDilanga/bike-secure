import 'package:cloud_firestore/cloud_firestore.dart';

class Database {

  Stream collectionStream = FirebaseFirestore.instance.collection('users').snapshots();

}