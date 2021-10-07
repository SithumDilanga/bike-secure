import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';

class map extends StatefulWidget {
  double lat, long;
  map({Key key, @required this.lat, @required this.long}) : super(key: key);

  @override
  _mapState createState() => _mapState();
}

class _mapState extends State<map> {
  var locationMessage = "";
  double latitude;
  double longtitude;
  double latitude1;
  double longtitude1;

  @override
  void initState() {
    latitude = widget.lat;
    longtitude = widget.long;
    // TODO: implement initState
    super.initState();
  }

  void updateCurrentLocation() async {
    var position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    var lastPosition = await Geolocator().getLastKnownPosition();
    print(lastPosition);

    var lat1 = position.latitude;
    var long1 = position.longitude;
    print("$lat1,$long1");
    setState(() {
      locationMessage = "$position";
      latitude = lat1;
      longtitude = long1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff000000),
        title: Text("My Location"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: PlatformMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(latitude, longtitude),
                  zoom: 16.0,
                ),
                markers: Set<Marker>.of(
                  [
                    Marker(
                      markerId: MarkerId('marker_1'),
                      position: LatLng(latitude, longtitude),
                      consumeTapEvents: true,
                      infoWindow: InfoWindow(
                        title: 'Location',
                        snippet: "Hi",
                      ),
                      onTap: () {
                        print("Marker tapped");
                      },
                    ),
                  ],
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                onTap: (location) => print('onTap: $location'),
                onCameraMove: (cameraUpdate) =>
                    print('onCameraMove: $cameraUpdate'),
                compassEnabled: true,
                onMapCreated: (controller) {
                  Future.delayed(Duration(seconds: 2)).then(
                    (_) {
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            bearing: 270.0,
                            target: LatLng(latitude, longtitude),
                            tilt: 0.0,
                            zoom: 18,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
