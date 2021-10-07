import 'dart:ui';
import 'package:bike_secure/screens/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var locationMessage = "";
  double latitude;
  double longtitude;

  void getCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);

    var lat = position.latitude;
    var long = position.longitude;
    print("$lat,$long");
    setState(() {
      locationMessage = "$position";
      latitude = lat;
      longtitude = long;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  bool isInDanger = false;

  final Stream<QuerySnapshot> _dataStream =
      FirebaseFirestore.instance.collection('bikeSecure').snapshots();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
          // backgroundColor: isInDanger ? Colors.red : Colors.green,
          body: StreamBuilder<QuerySnapshot>(
        stream: _dataStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong!');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          // get first document data in the collection
          QueryDocumentSnapshot<Object> docData = snapshot.data.docs.first;

          // get docData into a map
          Map<String, dynamic> bikeData =
              docData.data() as Map<String, dynamic>;

          // setting isInDanger value
          isInDanger = bikeData['isInDanger'];
          // print('bool ' + isInDanger.toString());

          return Column(
            children: [
              SizedBox(
                height: 50,
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
                height: 20,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                map(lat: latitude, long: longtitude)));
                    getCurrentLocation();
                  },
                  color: Colors.blue[800],
                  child: Text(
                    "Get current location",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ],
          );
        },
      )),
    );
  }
}
