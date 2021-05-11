import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
//import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home:LoginScreen(),theme: ThemeData(primaryColor: Colors.lightBlue,),));
}
Future<User> signInWithGoogle() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  UserCredential userCopy;
  // Trigger the authentication flow
  final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
  if (googleUser != null) {
  // Obtain the auth details from the request
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
  // Create a new credential
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  try {
      final UserCredential userCredential = await auth.signInWithCredential(credential);
      print("Google Sign-In Successful");
      userCopy=userCredential;
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      //_showMyDialog(e.code,);
      if (e.code == 'account-exists-with-different-credential') {
        // handle the error here
        print("account-exists-with-different-credential");
      }
      else if (e.code == 'invalid-credential') {
        // handle the error here
        print("invalid-credential");
      }
    } catch (e) {
      // handle the error here
      print(e);
    }
  }
  return userCopy.user;
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>with TickerProviderStateMixin {
  User chatUser;
  bool signedIn=false;
  bool loading=false;
  File _image;
  final picker = ImagePicker();
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  //final fb = FirebaseDatabase.instance;
  void checkSignIn(){
    FirebaseAuth.instance
    .authStateChanges()
    .listen((User user) {
    if (user == null) {
      setState(() {
      signedIn=false;
      });
      print('User signed out');
    } else {
      setState(() {
      signedIn=true;
      });
      print('User signed in');
    }
  });
  }

  @override
  Widget build(BuildContext context) {
    checkSignIn();
    //final ref = fb.reference();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          title: Center(child:Text('Register',style: TextStyle(color: Colors.grey[800]),)),
        ),
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background/theme.jpg'),
          fit: BoxFit.cover)
        ),
        child: loading? Center(child:SizedBox(child:CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
          strokeWidth: 5,
        ),height: 100,width: 100,),)
        :Column(children:
        [
          LinearProgressIndicator(
            value: signedIn? 1.0:0.5,
            valueColor: AlwaysStoppedAnimation(Colors.orangeAccent),
          ),
          signedIn ? profileUpdate():loginScreen()
        ]
        ),
        ),
      );
  }
  Widget loginScreen()
  {
    return Column(
          children:
          [
            Container(child:
              Text('IceChat',
                style: GoogleFonts.concertOne(fontSize: 40,
                  fontWeight: FontWeight.normal,
                  color: Colors.blue[800],
                  decoration: TextDecoration.underline,
                  ),
              ),
            margin: EdgeInsets.only(top: 190,bottom: 140),
            ),
            SignInButton(
              Buttons.Google,
              text: "Sign in with Google",
              onPressed: () async {setState((){loading=true;});chatUser= await signInWithGoogle();setState((){loading=false;});},
            )
          ]
          );
          
  }
  Widget profileUpdate()
  {
    return Column(children: 
    [
      SizedBox(height: 150,),
      SizedBox(child:
        ClipOval(child:
        _image == null
            ? 
        CachedNetworkImage(
          imageUrl: signedIn ? chatUser.photoURL:"https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg",
          placeholder: (context, url) => new CircularProgressIndicator(),
          errorWidget: (context, url, error) => new Icon(Icons.error),
          )
          : Image.file(_image,fit: BoxFit.fill,),
        ),
        height: 90,
        width: 90,
      ),
      TextButton(onPressed: (){getImage();}, child: Text('Change')),
      SizedBox(child:
       TextFormField(
         decoration: const InputDecoration(
              icon: Icon(Icons.person),
              hintText: 'Enter Full Name',
              labelText: 'Name',
              ),
              initialValue: signedIn? chatUser.displayName:'',
            ),
          width: 300,
          ),
      SizedBox(height: 10,),
      //ElevatedButton(onPressed: ()async { setState((){loading=true;});await GoogleSignIn().signOut();await FirebaseAuth.instance.signOut();setState((){loading=false;});}, child: Text('Logout')),
      ElevatedButton(child: Text('Continue'),onPressed:(){} ,),
    ],
    );
  }
}