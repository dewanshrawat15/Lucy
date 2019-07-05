import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:barcode_scan/barcode_scan.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.amber,
      ),
      debugShowCheckedModeBanner: false,
      home: MyCustomForm(),
    );
  }
}

class MyCustomForm extends StatefulWidget {
  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  @override
  void dispose() {
    super.dispose();
  }

  final google_blue = const Color(0xFF4285F4);
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await auth.signInWithCredential(credential);
    print("signed in " + user.displayName);
    return user;
  }

  Widget signInButton(){
   return new Container(
      child: new RaisedButton(
        onPressed: () => _handleSignIn().then((FirebaseUser user) => print(user)).catchError((e) => print(e)),
        padding: EdgeInsets.only(top: 3.0,bottom: 3.0,left: 3.0),
        color: const Color(0xFF4285F4),
        child: new Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Image.asset(
              'assets/images/google-logo.jpg',
              height: 52.0,
            ),
            new Container(
              padding: EdgeInsets.only(left: 10.0,right: 10.0),
                child: new Text("Sign in with Google",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
            ),
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.start,
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(32.0),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Lucy',
                style: TextStyle(fontSize: 32.0, color: Colors.white, fontFamily: "Product Sans",),
              ),
            ),
            Image.asset(
              'assets/images/lucy-logo-sm.png',
              width: 300.0,
              height: 300.0,
              fit: BoxFit.cover,
            ),
            signInButton(),
          ],
        ),
      ),
    );
  }
}