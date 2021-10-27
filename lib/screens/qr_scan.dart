import 'package:bike_secure/home.dart';
import 'package:bike_secure/services/database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class Scanner extends StatefulWidget {

  String userId;
  Scanner({ Key key, this.userId }) : super(key: key);

    @override
  _ScannerState createState() => _ScannerState();
}
 
class _ScannerState extends State<Scanner> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  DatabaseService _databaseService = DatabaseService();
 
  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

     void _onQRViewCreated(QRViewController controller) {
      //  this.controller = controller;
      //  controller.scannedDataStream.listen((scanData) async {
      //    //do something
      //    print('scan data1 ' + scanData.code.toString());
      //     controller.pauseCamera();
      //       if (await canLaunch(scanData.code)) {
      //         print('scan data2 ' + scanData.code.toString());
      //         await launch(scanData.code);
      //       }
      //     controller.resumeCamera();
      //  });
      this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      if (await canLaunch(scanData.code)) {
        await launch(scanData.code);
        controller.resumeCamera();
      } else {

        print('scan data ' + scanData.code.toString());
        print('userId ' + widget.userId.toString());

        DatabaseService(uid: widget.userId).updateUserWithQR(
          bikeId: scanData.code
        );

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Your bike code '),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Barcode Type: ${describeEnum(scanData.format)}'),
                    Text('ID: ${scanData.code}'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Ok'),
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Home(uid: widget.userId,))
                    );
                  },
                ),
              ],
            );
          },
        ).then((value) => controller.resumeCamera());
      }
    });
     }

    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
      ),
      body: Stack(
        children: [
          Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red,
                            width: 4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Center(
                  child: Text('Scan a code'),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}