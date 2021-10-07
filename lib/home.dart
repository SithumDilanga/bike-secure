import 'dart:async';
import 'dart:ui';
import 'package:bike_secure/screens/mymap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isInDanger = false;

  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _requestPermission();
    location.changeSettings(interval: 300, accuracy: loc.LocationAccuracy.high);
    location.enableBackgroundMode(enable: true);
  }

  final Stream<QuerySnapshot> _dataStream =
      FirebaseFirestore.instance.collection('bikeSecure').snapshots();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        // backgroundColor: isInDanger ? Colors.red : Colors.green,

        body: StreamBuilder<QuerySnapshot>(
            stream: _dataStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong!');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading...");
              }

              // get first document data in the collection
              QueryDocumentSnapshot<Object?> docData =
                  snapshot.data!.docs.first;

              // get docData into a map
              Map<String, dynamic> bikeData =
                  docData.data() as Map<String, dynamic>;

              // setting isInDanger value
              isInDanger = bikeData['isInDanger'];
              // print('bool ' + isInDanger.toString());

              return Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Container(
                        color: isInDanger ? Colors.red : Colors.green,
                      ),
                    ),
                    Container(
                      color: isInDanger ? Colors.red : Colors.green,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                isInDanger
                                    ? 'Your Bike is in Danger'
                                    : 'Your Bike is Safe',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 28.0,
                                ),
                              ),
                              SizedBox(
                                height: 28.0,
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
                    SizedBox(
                      height: 80,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: Container(
                          width: 200,
                          decoration: BoxDecoration(
                              color: Color(0xFFCFCFCF),
                              borderRadius: BorderRadius.circular(15)),
                          child: MaterialButton(
                            onPressed: () {
                              _getLocation();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.room,
                                  color: Colors.red,
                                ),
                                Text("Your Bike Location")
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('location')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return ListView.builder(
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(snapshot.data!.docs[index]['name']
                                    .toString()),
                                subtitle: Row(
                                  children: [
                                    Text(snapshot.data!.docs[index]['latitude']
                                        .toString()),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(snapshot.data!.docs[index]['longitude']
                                        .toString()),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.directions),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MyMap(snapshot
                                                .data!.docs[index].id)));
                                  },
                                ),
                              );
                            });
                      },
                    )),
                  ],
                ),
              );
            }),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': _locationResult.latitude,
        'longitude': _locationResult.longitude,
        'name': 'john'
      }, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  _requestPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      print('done');
    } else if (status.isDenied) {
      _requestPermission();
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> _listenLocation() async {
    _locationSubscription = location.onLocationChanged
        .listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance.collection('location').doc('user1').set({
        'latitude': currentlocation.latitude,
        'longitude': currentlocation.longitude,
        'name': 'My'
      }, SetOptions(merge: true));
    });
  }
}
