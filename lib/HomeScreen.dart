import 'dart:convert';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icechat/ChatScreen.dart';
import 'package:icechat/Register.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ins=FirebaseDatabase.instance;
  Map<String, dynamic> user;
  List<dynamic> userList=[];
  int c=0;
  bool load=false;
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
    onWillPop: () async => false,
    child:DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.blue,          
          title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:[
            Icon(Icons.camera_alt_rounded),
            Text('IceChat',
                style: GoogleFonts.concertOne(fontSize: 30,
                  fontWeight: FontWeight.normal,
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                  ),
                textAlign: TextAlign.center,
              ),
            PopupMenuButton(itemBuilder: (context) => [
                PopupMenuItem(child: 
                  TextButton(child:Text('Profile'),onPressed: (){},)
                ),
                PopupMenuItem(child:
                  TextButton(child:
                    Text('Sign Out'),
                    onPressed: ()async{
                      setState((){load=true;});
                      await GoogleSignIn().signOut();
                      await FirebaseAuth.instance.signOut();
                      setState((){load=false;});
                      Navigator.push(context,MaterialPageRoute(builder: (context) => LoginScreen()));
                      },
                  )
                )
              ],
              tooltip: 'Settings',
              child: Icon(Icons.more_vert),)
            ]
          ),
          bottom: TabBar(
            //isScrollable: true,
            indicatorColor: Colors.white,
            indicatorWeight: 3.0,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[600],
            tabs: [
              Tab(text: 'Chats',),
              Tab(text: 'Users',),
            ],
          ),
        ),
        body: load? 
        Center(child:SizedBox(child:CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
          strokeWidth: 5,
        ),height: 100,width: 100,),)
        :TabBarView(
            children: [
              Column(children: [chats()],),
              Column(children: [users()],),
            ]
          )
    )
    )
    );
  }

  Widget chats() {
    return Container();  
  }

  Widget users() {
    final refer=ins.reference();
    refer.child('IceChat').child('UserList').once().then(
      (DataSnapshot snapshot)
      {
        setState(()
        {
          user=jsonDecode(snapshot.value.toString());
          var it=user.keys.iterator;
          while (it.moveNext()) {
            if(c<user.keys.length&&it.current!=FirebaseAuth.instance.currentUser.uid)
            userList.add(it.current);
            c++;
          }
        }
        );
        if(c==user.keys.length)
        print(userList);
        if(c>user.keys.length)
        c=user.keys.length;
      }
    );
    //print(userList);
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
          return Card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading:ClipOval(child:Image.network(user['${userList[index]}']["photoUrl"].toString())),
                  title: Text(user['${userList[index]}']["Name"].toString()),
                  subtitle: Column(children:[
                    Row(children:[
                      Icon(Icons.check_circle_rounded,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Flexible(child:
                        Text(
                          'Hi Mayank! Lorem Ipsum falana dhimkana',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                    Row(children:[SizedBox(width: 25,),Text('Delivered')]),
                    ]),
                  isThreeLine: true,
                  trailing: Column(children:[SizedBox(height: 35,),Text('08:25 pm')]),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen(index,user,userList)),);
                      refer.child('IceChat').child('UserData')
                      .child('\"${FirebaseAuth.instance.currentUser.uid}\"')
                      .child('\"${userList[index]}\"')
                      .set({
                      '\"receive\"':"\"null\"",
                      '\"receive_confirm\"':'\"null\"',
                      '\"sent\"':'\"null\"',
                      '\"sent_confirm\"':'\"null\"',
                    });
                    },
                )
              ],
          ),
        );
      }
    );
  }
}