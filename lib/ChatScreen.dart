//import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
List msg;
//Map savedChat={};
class ChatScreen extends StatefulWidget {
  int c=0;
  List<dynamic> message=[];//[['Hi','send','10:00 am'],['Hello ','receive','10:01 am'],['How are you?','receive','10:01 am'],['I am Fine','send','10:02 am']]; 
  final int pos;
  final Map<String,dynamic> user;
  final List<dynamic> userList;
  var savedChat={};
  var readChat={};
  _save(msg) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/message_backup.txt');
    await file.writeAsString("$msg");
    print(msg.toString());
    print('Message Backup Successful');
  }
  _read() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      //print(directory);
      final file = File('${directory.path}/message_backup.txt');
      String text = await file.readAsString();
      return text;
      //print(text);
    } catch (e) {
      print("Couldn't read file");
      _save('');
      return '';
    }
  }
  ChatScreen(this.pos,this.user,this.userList);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  TextEditingController input = new TextEditingController();
  bool empty=true;
  var adder;
  final ins=FirebaseDatabase.instance;
  var temp,tempSend;
  bool enable=false;
  extractChat(String data){
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
    setState((){widget.message=a;});
  }
  void reader() async {
    var abcd= await widget._read();
    print(abcd);
    if(abcd.toString().isEmpty==false)
    widget.readChat=jsonDecode(abcd);
    //print(widget.savedChat['Y5mwn0wlpfhs36yz9u4AVo3H15X2']);
    //widget.savedChat['Y5mwn0wlpfhs36yz9u4AVo3H15X2'];
    if(widget.readChat!=null)
    {
    String c=widget.readChat['${widget.userList[widget.pos]}'];
    //print(widget.readChat['${widget.userList[widget.pos]}'].runtimeType);
    extractChat(c);
    //var h={'\"${widget.userList[widget.pos]}\"':'\"$c\"'};
    //widget.message=widget.readChat["${widget.userList[widget.pos]}"];
    //widget.savedChat.addAll(h);
    widget.readChat.forEach((key, value) {var h={'\"${key.toString()}\"':'\"${value.toString()}\"'};widget.savedChat.addAll(h);});
    //print(c);
    }
    //widget.savedChat=widget.readChat;
    //print(widget.message.runtimeType);
    //print(widget.savedChat);
  }
  void saver() async{
    if(widget.message.isEmpty==false)
    {
    //print(widget.savedChat);
    //widget.savedChat.update("\"${widget.userList[widget.pos]}\"",(v)=>"\"${widget.message.toString()}\"",ifAbsent: ()=>"\"${widget.message.toString()}\"");
    var h={'\"${widget.userList[widget.pos]}\"':'\"${widget.message.toString()}\"'};
    widget.savedChat.addAll(h);
    //print(h.runtimeType);
    print(widget.savedChat);
    }
    widget._save(widget.savedChat);
  }
  void receive(){
    final refer=ins.reference();
    var loc=
    refer
    .child('IceChat')
    .child('UserData')
    .child('\"${FirebaseAuth.instance.currentUser.uid}\"')
    .child('\"${widget.userList[widget.pos]}\"')
    .child('\"receive\"');
    loc..onValue.listen((event) {
      var snap=event.snapshot;
      //message.remove(['Hello', 'receive', '13:10']);
      if(snap.value!='null')
      { 
      DateTime now= new DateTime.now();
      String currentTime;
      currentTime=now.hour.toString()+':'+now.minute.toString()+' ';
      setState(() {
        enable=true;
        temp=["${snap.value}","receive","$currentTime"];
      });
      //widget.message.add(temp);
      loc.set('null');
      saver();
      //print(currentTime);
      //message.add(['${snap.value}','receive','$currentTime']);
      }
      // if(message.isEmpty==false)
      // print(message);
      // if(this.mounted)
      // setState(() {});
    });
  }
  void send(String s){
    final refer=ins.reference();
    var loc=
    refer
    .child('IceChat')
    .child('UserData')
    .child('\"${widget.userList[widget.pos]}\"')
    .child('\"${FirebaseAuth.instance.currentUser.uid}\"')
    .child('\"receive\"');
    loc.set(s);
    DateTime now= new DateTime.now();
    String currentTime;
    currentTime=now.hour.toString()+':'+now.minute.toString()+' ';
    widget.message.add(["$s","sent","$currentTime"]);
    saver();
  }
  @override
  Widget build(BuildContext context) {
    if(widget.c==0)
    {
    reader();
    setState(() {});
    widget.c++;
    }
    //print(widget.message);
    //final refer=ins.reference();
    // if(savedChat!=null)
    // widget.message=savedChat['${widget.userList[widget.pos]}'];
    return WillPopScope(
      onWillPop: () async {
        // if(savedChat!=null)
        //print(widget.message.runtimeType);
        //print(widget.message);
        //widget.savedChat["\"${widget.userList[widget.pos]}\""]="\"${widget.message.toString()}\"";
        //String x=widget.savedChat.toString();
        saver();
        //print(x);
        //if(savedChat['${widget.userList[widget.pos]}']!=null)
        //widget._save('');
        return true;
      },
      child: Scaffold(
      appBar: AppBar(
      //automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children:[
          //SizedBox(child:IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: ()=>Navigator.pop(context),),),
          SizedBox(child:
            ClipOval(child: 
              Image.network(widget.user['${widget.userList[widget.pos]}']['photoUrl'].toString())
            ),
          height: 40,
          //width: 40,
          ),
          SizedBox(width: 10,),
          Column(crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Text(widget.user['${widget.userList[widget.pos]}']['Name'].toString(),style: TextStyle(fontSize: 18,color: Colors.white),),
            Text('Online',style:TextStyle(fontSize: 12,color: Colors.black)),
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
          IconButton(icon:Icon(Icons.phone), onPressed: () {},),
          IconButton(icon:Icon(Icons.videocam),onPressed: (){},),
          PopupMenuButton(itemBuilder: (context) => [
                PopupMenuItem(child: Text('Profile')),
                PopupMenuItem(child: Text('Block')),
              ],
              tooltip: 'More Options',
              child: Icon(Icons.more_vert),
              color: Colors.lightBlueAccent[100],
            ),
            ]
            ),
          ]
        ),
      ),
      body: Stack(children:[
        chatLayout(),
        Align(child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(child:
                TextFormField(textInputAction: TextInputAction.newline,
                  onChanged: (s){setState(() {empty=false;});},
                  //onFieldSubmitted:(s){input.text=s;} ,
                  controller: input,
                  maxLines: null,
                  decoration: new InputDecoration(
                    contentPadding: new EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    hintText: 'Type a message',
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(50.0),
                      borderSide: new BorderSide(
                      ),
                    ),
                    //fillColor: Colors.green
                  ),
                ),
              //height: 40,
              width: 0.75*MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 10,bottom: 20),
              ),
              Container(child:
              FloatingActionButton(
                  child: input.text==''?Icon(Icons.mic,size: 30,):Icon(Icons.send_rounded,size: 30,),
                  onPressed: (){if(input.text.trim().isEmpty==false){send(input.text.trim());setState(() {});input.text='';}}
                ),
              padding: EdgeInsets.only(bottom:20,right: 10),
              ),
            ]),
          alignment: Alignment.bottomLeft,
          ),
      ]),
    )
    );
  }
  Widget chatLayout(){
    receive();
    if(temp!=null&&enable==true)
    widget.message.add(temp);
    print(widget.message);
    enable=false;
    return Container(
      child: 
        ListView.builder(
          itemCount: widget.message.length,
          itemBuilder: (BuildContext context, int index) {
            return Align(child:
              Container(
                child:IntrinsicWidth(child:
                  Stack(children:[
                      Container(child:
                        Text('${widget.message[index][0]}',
                        style: TextStyle(fontSize: 14,),
                        maxLines: null,
                        ),
                        constraints: BoxConstraints(minWidth: 60,maxWidth: 250),
                        margin: EdgeInsets.only(bottom:14),
                      ),
                      Positioned(child: 
                      Text('${widget.message[index][2]}',style: TextStyle(fontSize: 9),),
                      bottom: 1,
                      right: 1,
                      ),
                    ]),
                    ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.lightBlue[100],
                  ),
                padding: EdgeInsets.only(left:10,right: 10,bottom: 5,top:5),
                margin: EdgeInsets.symmetric(vertical:1,horizontal: 5),
                constraints: BoxConstraints(minWidth: 50,maxWidth:MediaQuery.of(context).size.width*0.8,),
              ),
              alignment: widget.message[index][1].toString().trim()=='receive'?Alignment.centerLeft:Alignment.centerRight,
            );
            }
          )
    );
  }
}