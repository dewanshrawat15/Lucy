import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
// import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatelessWidget {
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

  final databaseReference = FirebaseDatabase.instance.reference();
  var user_id = '';
  void createRecord(String urlText) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss EEE d MMM').format(now);
    databaseReference.child(uid).push().set({
      'URL': urlText,
      'time': formattedDate,
    });
  }

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      if(await canLaunch(qrResult)){
        createRecord(qrResult);
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

  _setUserIDFunction() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    user_id = user.uid;
  }

  @override
  void initState() {
    _setUserIDFunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Lucy"),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(32.0),
                ),
                Text(
                  'Your History',
                  style: TextStyle(fontSize: 25.0, fontFamily: 'Product Sans'),
                ),
                Padding(
                  padding: EdgeInsets.all(32.0),
                ),
                Flexible(
                  child: StreamBuilder(
                    stream: databaseReference.child('$user_id').onValue,
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData){
                        return Text("${snapshot.data}");
                      }
                      else{
                        return CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(32.0),
                ),
              ],
            ),
          ),
        ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          FloatingActionButton(
            onPressed: (){
              print(user_id);
            },
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
