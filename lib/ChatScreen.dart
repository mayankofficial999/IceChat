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
  List<dynamic> message =[['Hi','send','10:00 am'],['Hello ','receive','10:01 am'],['How are you?','receive','10:01 am'],["I am Fine ",'send','10:02 am']];
  TextEditingController input = new TextEditingController();
  bool empty=true;
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
      body: Stack(children:[
        chatLayout(),
        Align(child:
          Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(child:
                TextFormField(
                  onChanged: (s){setState(() {empty=false;});},
                  onFieldSubmitted:(s){input.text=s;} ,
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
                  onPressed: (){}
                ),
              padding: EdgeInsets.only(bottom:20,right: 10),
              ),
            ]),
          alignment: Alignment.bottomLeft,
          ),
      ]),
    );
  }

  Widget chatLayout(){
    return Container(
      child: 
        ListView.builder(
          itemCount: message.length,
          itemBuilder: (BuildContext context, int index) {
            return Align(child:
              Container(
                child:IntrinsicWidth(child:
                  Stack(children:[
                      Container(child:
                        Text('${message[index][0]}',
                        style: TextStyle(fontSize: 14,),
                        maxLines: null,
                        ),
                        constraints: BoxConstraints(minWidth: 60,maxWidth: 250),
                        margin: EdgeInsets.only(bottom:14),
                      ),
                      Positioned(child: 
                      Text('${message[index][2]}',style: TextStyle(fontSize: 9),),
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
              alignment: message[index][1]=='receive'?Alignment.centerLeft:Alignment.centerRight,
            );
            }
          )
    );
  }
}