//import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final int pos;
  final Map<String,dynamic> user;
  final List<dynamic> userList;
  ChatScreen(this.pos,this.user,this.userList);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //final ins=FirebaseDatabase.instance;
  @override
  Widget build(BuildContext context) {
    //final refer=ins.reference();
    return Scaffold(
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
      body: Container(),
    );
  }
}