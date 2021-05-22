import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icechat/ChatScreen.dart';
import 'package:icechat/Register.dart';
import 'package:path_provider/path_provider.dart';
class HomePage extends StatefulWidget {
  List<dynamic> chatList=[];
  var chatData={};
  String lastMessage,lastTime,lastMessage1,lastTime1='';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ins=FirebaseDatabase.instance;
  Map<String, dynamic> user;
  List<dynamic> userList=[];
  int c=0;
  bool load=false;
  extractLastChat(String data){
    List a=[];
    List b=[];
    String c=data.toString().substring(1,data.toString().length-1);
    for(int i=0;i<c.length;i++){
    if(c[i]=='['){
      String s='';
      for(int j=i+1;j<c.length;j++)
      {
        if(c[j]!=','&&c[j]!=']')
        {s+=c[j];}
        else if(c[j]==',')
        {
          b.add(s.trim());
          s='';
        }
        else if(c[j]==']')
        {b.add(s.trim());s='';a.add(b);b=[];break;}
      }
    }
    }
    return a;
  }
  _readLastMessage() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      //print(directory);
      final file = File('${directory.path}/message_backup.txt');
      String text = await file.readAsString();
      return text;
      //print(text);
    } catch (e) {
      print("Couldn't read file");
      return '';
    }
  }
  getLastMessage() async{
    var temp;
    var abcd= await _readLastMessage();
    if(abcd.toString().isEmpty==false)
    temp=jsonDecode(abcd);
    if(temp!=null)
    {
      for(int i=0;i<userList.length;i++)
      {
      String c=temp['${userList[i]}'];
      var h={'\"${userList[i]}\"':extractLastChat(c)};
      widget.chatData.addAll(h);
      }
      //print(widget.chatData['\"Ej2d0oyOieVQoLt5WvOyPND4PiG3\"'][widget.chatData['\"Ej2d0oyOieVQoLt5WvOyPND4PiG3\"'].length-1][0]);
    }
  }
  resetSave() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/message_backup.txt');
    await file.writeAsString("");
    print(msg.toString());
    print('Message Backup Successful');
  }
  _save(msg) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/chatList_backup.txt');
    await file.writeAsString("$msg");
    if(msg.toString().isEmpty==false)
    print(msg.toString());
    print('Message Backup Successful');
  }
  _read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      //print(directory);
      final file = File('${directory.path}/chatList_backup.txt');
      String text = await file.readAsString();
      return text;
      //print(text);
    } catch (e) {
      print("Couldn't read file");
      _save('');
      return '';
    }
  }
  extractChat(String data){
    List a=[];
    for(int i=0;i<data.length;i++){
    if(data[i]=='['){
      String s='';
      for(int j=i+1;j<data.length;j++)
      {
        if(data[j]!=','&&data[j]!=']')
        {s+=data[j];}
        else if(data[j]==',')
        {
          a.add(s.trim());
          s='';
        }
        else if(data[j]==']')
        {a.add(s.trim());s='';break;}
      }
    }
    }
    setState((){widget.chatList=a;});
  }
  reader() async {
    var x=await _read();
    if(x.toString().isEmpty==false)
    {
    extractChat(x.toString());
    //print(widget.chatList);
    }
  }
  @override
  Widget build(BuildContext context) {
    reader();
    //print(message);
    //_save('');
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
                      resetSave();
                      _save('');
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
        body: Container(
      constraints: BoxConstraints.expand(),
        //Add Background Image
        decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/background/homeBackground.jpg'),
          fit: BoxFit.cover)
        ),
          child:load? 
        Center(child:SizedBox(child:CircularProgressIndicator(
          backgroundColor: Colors.white,
          valueColor: AlwaysStoppedAnimation(Colors.lightBlue),
          strokeWidth: 5,
        ),height: 100,width: 100,),)
        :TabBarView(
            children: [
              Column(children: [widget.chatList.isEmpty==false&&user!=null?chats():Column(children: [SizedBox(height:50),Text('Start a Conversation!')])],),
              Column(children: [users()],),
            ]
          )
      )
    )
    )
    );
  }

  Widget chats() {
    final refer=ins.reference();
    return new ListView.builder(
      shrinkWrap: true,
      itemCount: widget.chatList.length,
      itemBuilder: (BuildContext context, int index) {
          var last='Start a Conversation',ltime='';
          getLastMessage();
          //print(widget.chatData['\"${widget.chatList[index]}\"']);
          if(widget.chatData.isEmpty==false)
          {
          if(widget.chatList.isEmpty==false&&(widget.chatData['\"${widget.chatList[index]}\"']!=null))
          {
            last=widget.chatData['\"${widget.chatList[index]}\"'][widget.chatData['\"${widget.chatList[index]}\"'].length-1][0];
            ltime=widget.chatData['\"${widget.chatList[index]}\"'][widget.chatData['\"${widget.chatList[index]}\"'].length-1][2];
          }
          else
          {
            last='Start a conversation';
            ltime='';
          }
          }
          return Card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200),),
                  leading:ClipOval(child:
                    CachedNetworkImage(
                      imageUrl:user['${widget.chatList[index]}']["photoUrl"].toString(),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>CircularProgressIndicator(value: downloadProgress.progress),
                      errorWidget: (context, url, error) => new Icon(Icons.error),)),
                  title: Text(user['${widget.chatList[index]}']["Name"].toString()),
                  subtitle: Column(children:[
                    Row(children:[
                      Icon(Icons.check_circle_rounded,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Flexible(child:
                        Text(
                          "$last",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                    Row(children:[SizedBox(width: 25,),Text('Delivered')]),
                    ]),
                  isThreeLine: true,
                  trailing: Column(children:[SizedBox(height: 35,),Text('$ltime')]),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen(index,user,widget.chatList)),);
                      var db=refer.child('IceChat').child('UserData')
                      .child('\"${FirebaseAuth.instance.currentUser.uid}\"');
                      //.child('\"${userList[index]}\"');
                      db.orderByKey().equalTo('\"${widget.chatList[index]}\"').once()
                      .then((DataSnapshot snap) {
                        print(snap.value);
                        if(snap.value==null)
                        {db..child('\"${widget.chatList[index]}\"')
                        .set({'\"receive\"':"null",
                        });
                        }
                        });
                    },
                )
              ],
          ),
        );
      }
    );  
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
          var last='Start a conversation',ltime='';
          getLastMessage();
          //print(widget.chatData['\"${userList[index]}\"']);
          //print((widget.chatData['\"${userList[index]}\"'] as List).isEmpty);
          if(widget.chatData.isEmpty==false)
          {
          if(userList.isEmpty==false&&(widget.chatData['\"${userList[index]}\"'] as List).isEmpty==false)
          {
            //print(widget.chatData['\"${userList[index]}\"']);
            last=widget.chatData['\"${userList[index]}\"'][widget.chatData['\"${userList[index]}\"'].length-1][0];
            ltime=widget.chatData['\"${userList[index]}\"'][widget.chatData['\"${userList[index]}\"'].length-1][2];
          }
          else
          {
            last='Start a conversation';
            ltime='';
          }
          }
          return Card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading:ClipOval(child:CachedNetworkImage(imageUrl:user['${userList[index]}']["photoUrl"].toString(),progressIndicatorBuilder: (context, url, downloadProgress) =>CircularProgressIndicator(value: downloadProgress.progress),)),
                  title: Text(user['${userList[index]}']["Name"].toString()),
                  subtitle: Column(children:[
                    Row(children:[
                      Icon(Icons.check_circle_rounded,color: Colors.blue,),
                      SizedBox(width: 10,),
                      Flexible(child:
                        Text(
                          '$last',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                    Row(children:[SizedBox(width: 25,),Text('Delivered')]),
                    ]),
                  isThreeLine: true,
                  trailing: Column(children:[SizedBox(height: 35,),Text('$ltime')]),
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context) => ChatScreen(index,user,userList)),);
                    var db=refer.child('IceChat').child('UserData')
                      .child('\"${FirebaseAuth.instance.currentUser.uid}\"');
                      //.child('\"${userList[index]}\"');
                    db.orderByKey().equalTo('\"${userList[index]}\"').once()
                      .then((DataSnapshot snap) {
                        print(snap.value);
                        if(snap.value==null)
                        {db..child('\"${userList[index]}\"')
                        .set({'\"receive\"':"null",
                        });
                        }
                        });
                    if(widget.chatList.contains(userList[index])==false)
                    {
                      widget.chatList.add(userList[index]);
                      _save(widget.chatList.toString());
                    }
                    },
                )
              ],
          ),
        );
      }
    );
  }
}