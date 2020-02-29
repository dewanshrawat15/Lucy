import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AccountScreen extends StatefulWidget {

  final String name, email, photoUrl;
  AccountScreen({this.name, this.email, this.photoUrl});

  @override
  _AccountScreenState createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: (){
            Navigator.pop(context);
          },
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Icon(Icons.chevron_left),
          )
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              ),
              CircleAvatar(
                radius: 64,
                backgroundImage: NetworkImage(
                  widget.photoUrl
                ),
              ),
              SizedBox(
                height: 64,
              ),
              Text(
                widget.name,
                style: TextStyle(
                  fontFamily: "Product Sans",
                  fontSize: 36
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Text(
                widget.email,
                style: TextStyle(
                  fontFamily: "Product Sans",
                  fontSize: 20
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 4,
              )
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async{
      //     await auth.signOut();
      //     await googleSignIn.signOut();
      //     Navigator.pop(context);
      //     setState(() {
      //       var tempWidget = super.widget;
      //       tempWidget.logOutDealer();
      //     });
      //   },
      //   child: Icon(Icons.power_settings_new),
      // ),
    );
  }
}