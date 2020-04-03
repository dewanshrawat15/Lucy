import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'pages/home.dart';

void main(){
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      theme: ThemeData(
        primaryColor: Colors.amber,
        accentColor: Colors.amber,
        buttonColor: Colors.amber,
      ),
    )
  );
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  String name, email, displayPicture;

  final googleBlue = const Color(0xFF4285F4);
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
    return user;
  }

  Widget signInButton(){
   return new Container(
      child: new RaisedButton(
        onPressed: () async{
          FirebaseUser user = await _handleSignIn();
          name = user.displayName;
          email = user.email;
          displayPicture = user.photoUrl;       
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(
                name: name,
                email: email,
                displayPicURL: displayPicture,
              )
            )
          );
        },
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

  signInSilently() async{
    var user = await googleSignIn.signInSilently();
    name = user.displayName;
    email = user.email;
    displayPicture = user.photoUrl;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(
          name: name,
          email: email,
          displayPicURL: displayPicture,
        )
      )
    );
  }

  @override
  void initState() {
    signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Lucy',
                  style: TextStyle(
                    fontSize: 32.0,
                    color: Colors.white,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
              Image.asset(
                'assets/images/lucy-logo-sm.png',
                width: 300.0,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              signInButton(),
              SizedBox(
                height: 64,
              )
            ],
          ),
        ),
      )
    );
  }
}