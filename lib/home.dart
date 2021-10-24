import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {

  final String uid;

  const Home({ Key? key, required this.uid }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool isInDanger = false;

  // final Stream<QuerySnapshot> _dataStream = FirebaseFirestore.instance.collection('bikeSecure').snapshots();

  @override
  Widget build(BuildContext context) {

    final Stream<DocumentSnapshot> _dataStream = FirebaseFirestore.instance.collection("users").doc(widget.uid).snapshots();
 

    return Material(
      child: Scaffold(
        // backgroundColor: isInDanger ? Colors.red : Colors.green,
        appBar: AppBar(
          title: Text(
            'Bike Secure'
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue[800],
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: _dataStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text('Something went wrong!');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }


            // get first document data in the collection
            // QueryDocumentSnapshot<Object?> docData = snapshot.data!.docs.first;

            DocumentSnapshot<Object?>? docData = snapshot.data;

            // get docData into a map
            Map<String, dynamic> bikeData = docData!.data() as Map<String, dynamic>;

            // setting isInDanger value
            isInDanger = bikeData['isInDanger'];
            // print('bool ' + isInDanger.toString());

            return Container(
              color: isInDanger ? Colors.red : Colors.green,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Your Bike ID - ${bikeData['bikeId']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 284.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            isInDanger ? 'Your Bike is in Danger' : 'Your Bike is Safe' ,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28.0,
                            ),
                          ),
                          SizedBox(height: 28.0,),
                          Icon(
                            Icons.check_circle_outline_rounded,
                            color: Colors.white,
                            size: 28.0,
                          )
                        ],
                      ),
                    ],
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