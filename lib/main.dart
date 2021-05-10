import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:LoginScreen(),theme: ThemeData(primaryColor: Colors.lightGreen[50],),));
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final fb = FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    final ref = fb.reference();
    return Scaffold(
      appBar: AppBar(
          title: Text('Test'),
        ),
      body: Center(child: 
       ElevatedButton(
              onPressed: ()  {
                ref.child("Users").child("8ewdhuhde").set({
                  'message_received':'Hey! Old Pro','message_sent':'Hey! Old Noob'
                });
                //ref.child("Users").child("UID").child("message_sent").set("Hi!");
                //print('This Line Executes.');
                ref.once().then((DataSnapshot data) {
                  print('Data is ${data.value}');
                });
              },
              child: Text("Submit"),
            ),
        ),
      );
  }
}