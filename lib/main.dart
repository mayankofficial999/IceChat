import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:icechat/HomeScreen.dart';
import 'Register.dart';
//import 'HomeScreen.dart';
//import 'package:firebase_database/firebase_database.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MaterialApp(home:FirebaseAuth.instance.currentUser!=null?HomePage():LoginScreen(),theme: ThemeData(primaryColor: Colors.lightBlue,),));
}