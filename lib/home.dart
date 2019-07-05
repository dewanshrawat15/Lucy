import 'package:flutter/material.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  String result = "";

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      if(await canLaunch(qrResult)){
        _launchURL(qrResult);
      }
      else{
        print("Out of league");
      }
      // Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => tickDisplay()));
    }on FormatException {
      print("You are a noob");
    } catch (ex) {
      print("$ex");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lucy"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32.0),
            ),
            Text(
              'Your History',
              style: TextStyle(fontSize: 25.0, fontFamily: 'Product Sans'),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            heroTag: 'image0',
            tooltip: 'Generate QR',
            child: const Icon(Icons.image),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              heroTag: 'image1',
              onPressed: _scanQR,
              tooltip: 'Scan',
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ],
      ),
    );
  }
}
