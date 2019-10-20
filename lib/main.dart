import 'package:flutter/material.dart';
import 'package:lucy/app.dart';
import 'package:flutter/services.dart';
// import 'dart:async';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'home.dart';

// void main() => runApp(MyApp());

void main(){
  // TODO : adding Preferences to projects
  // TODO : adding Bloc Achicture
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, DeviceOrientation.portraitDown
  ]);
  return runApp(MyApp());
}