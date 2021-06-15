import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_admin/constant/appcolors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String sender;
  ChatScreen(this.sender);
  @override
  _ChatScreenState createState() => _ChatScreenState(sender);
}

class _ChatScreenState extends State<ChatScreen> {
  final String sender;
  _ChatScreenState(this.sender);
  double _height=0;
  double _width=0;
  ScrollController _scrollController=ScrollController();
  Query _chatsQuery;
  TextEditingController _message=TextEditingController();
  var _data;

  @override
  void initState() {
    _data=_getChats();
    // Timer(Duration(seconds: 2), (){
    //   _scrollController.animateTo(
    //     _scrollController.position.maxScrollExtent,
    //     curve: Curves.easeOut,
    //     duration: const Duration(milliseconds: 500),
    //   );
    // });
    super.initState();
  }

  _getChats()async{
    _chatsQuery=FirebaseFirestore.instance.collection("chats")
        .where("roomId",isEqualTo: sender,)
        .orderBy("messageTime",descending: true).limitToLast(50);
  }

  @override
  Widget build(BuildContext context) {
    _height=MediaQuery.of(context).size.height;
    _width=MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: Text("Talk to us"),
        backgroundColor: AppColors.backgroundColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if(snapshot.connectionState==ConnectionState.done){
              return  Stack(
                children: [
                  Container(
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            Container(
                              height: _height*8.5/10,
                              padding: EdgeInsets.all(10),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: _chatsQuery.snapshots(),
                                  builder: (context, snapshot) {
                                    if(!snapshot.hasData) return Center(child: CircularProgressIndicator(),);
                                    if(snapshot.data.docs.length==0) return Center(
                                      child: Text("Need Help!",style: TextStyle(color: Colors.grey,fontSize: 30,fontWeight: FontWeight.bold),),
                                    );
                                    return ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      primary: false,
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemCount: snapshot.data.docs.length,
                                      itemBuilder: (context,i){
                                       if(snapshot.data.docs[i].get("rec")=="admin"){
                                         snapshot.data.docs[i].reference.update({
                                           "status":"read"
                                         });
                                       }
                                        return snapshot.data.docs[i].get('rec')=="user"
                                            ?_userMessage(snapshot.data.docs[i].get('message'),snapshot.data.docs[i].get('time'))
                                            :_adminMessage(snapshot.data.docs[i].get('message'),snapshot.data.docs[i].get('time'));
                                      },
                                    );
                                  }
                              ),
                            ),
                            SizedBox(height: _height*0.7/10,)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      child: Container(
                        padding: EdgeInsets.only(left: 15),
                        width: _width,
                        height: _height*0.7/10,
                        decoration: BoxDecoration(
                            color: Colors.white
                        ),
                        child: Row(
                          children: [
                            Expanded(child: TextFormField(
                              controller: _message,
                              decoration: InputDecoration(
                                  hintText: "Enter Message..."
                              ),
                            )),
                            IconButton(
                                onPressed: (){
                                  _sendMessage();
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: AppColors.textColor,
                                  size: 35,
                                )
                            )
                          ],
                        ),
                      ))
                ],
              );
            }else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

  Widget _adminMessage(message,time){
    return Padding(
      padding: EdgeInsets.all(10),
      child: Container(
        width: _width*8/10,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.textColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(message,style: TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _userMessage(message,time){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: _width*8/10,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(message,style: TextStyle(color: Colors.black),),
      ),
    );
  }

  _sendMessage()async{
    CollectionReference ref = FirebaseFirestore.instance.collection("chats");
    if(_message.text.trim().isNotEmpty){

      ref.add({
        "roomId":sender,
        "rec":"user",
        "messageTime":DateTime.now(),
        "message":_message.text,
        "time":DateFormat("HH:mm").format(DateTime.now()),
        "status":"new"
      }).whenComplete((){
        _message.text="";
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 500),
        );

      });
    }
  }
}



