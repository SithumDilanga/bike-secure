import 'dart:ui';

import 'package:bike_secure/services/databse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isInDanger = false;
  Database database = Database();

  final Stream<QuerySnapshot> _dataStream = FirebaseFirestore.instance.collection('bikeSecure').snapshots();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Bike Secure'
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[800],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _dataStream,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong!');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }

            // get first doc data in the collection
            QueryDocumentSnapshot<Object?> docData = snapshot.data!.docs.first;

            // get docData into a map
            Map<String, dynamic> bikeData = docData.data() as Map<String, dynamic>;

            // setting isInDanger value
            isInDanger = bikeData['isInDanger'];
            // print('bool ' + isInDanger.toString());

            return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Material(
              elevation: 5,
              child: Container(
                // margin: EdgeInsets.all(8.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isInDanger ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(5.0)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isInDanger ? 'Your Bike is in Danger' : 'Your Bike is Safe' ,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      ),
                      Icon(
                        Icons.check_circle_outline_rounded,
                        color: Colors.white,
                        size: 28.0,
                      )
                    ],
                  ),
                ),
              ),
            ),
          );

          } 
        ),
      ),
    );
  }
}