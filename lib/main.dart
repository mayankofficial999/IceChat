import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:icechat/HomeScreen.dart';
//import 'package:path_provider/path_provider.dart';
import 'Register.dart';
//import 'HomeScreen.dart';
//import 'package:firebase_database/firebase_database.dart';
// _save(msg,s) async {
//   final directory = await getApplicationDocumentsDirectory();
//   final file = File('${directory.path}/$s');
//   await file.writeAsString("$msg");
//   if(msg.toString().isEmpty==false)
//   print(msg.toString());
//   print('Message Backup Successful');
// }
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(MaterialApp(home:FirebaseAuth.instance.currentUser!=null?HomePage():LoginScreen(),theme: ThemeData(primaryColor: Colors.lightBlue,),));
}