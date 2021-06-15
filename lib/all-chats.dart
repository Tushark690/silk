import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_admin/model/chat-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllChats extends StatefulWidget {
  @override
  _AllChatsState createState() => _AllChatsState();
}

class _AllChatsState extends State<AllChats> {

  CollectionReference  _query= FirebaseFirestore.instance.collection("chats");

  Map<String,int> _newMessageMap=Map();
  List<String> _oldChatList=[];

  _getChats()async{
    SharedPreferences sp = await SharedPreferences.getInstance();

    _query.where("status",isEqualTo: "new")
        .where("rec",isEqualTo: "admin").get().then((QuerySnapshot snapshot) {
            snapshot.docs.forEach((element) {
              // sp.remove(element.get("roomId"));
              if(sp.getStringList(element.get("roomId"))==null){
                ChatModel chatModel = ChatModel();
                chatModel.rec=element.get("rec");
                chatModel.roomId=element.get("roomId");
                chatModel.message=element.get("message");
                chatModel.messageTime=element.get("messageTime").toString();
                List<String> list = [];
                list.add(jsonEncode(chatModel.toJson()));
                sp.setStringList(element.get("roomId"), list);
                _newMessageMap.update(element.get("roomId"), (value) => value+1,ifAbsent: () => 1,);
              }else{
                List<String> a =sp.getStringList(element.get("roomId"));
                ChatModel chatModel = new ChatModel();
                chatModel.rec=element.get("rec");
                chatModel.roomId=element.get("roomId");
                chatModel.message=element.get("message");
                chatModel.messageTime=element.get("messageTime").toString();
                a.add(jsonEncode(chatModel.toJson()));
                sp.setStringList(element.get("roomId"), a);
                _newMessageMap.update(element.get("roomId"), (value) => value+1,ifAbsent: () => 1,);
              }
              // sp.remove(element.get("roomId"));
              element.reference.delete();
            });
      } );

      print(sp.getStringList("8957539851"));
      print(_newMessageMap['8957539851']);


    _oldChatList=sp.getStringList("8957539851");
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Chats"),
      ),
      body: FutureBuilder(
        future: _getChats(),
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.done){
            return Container(
              child: SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _query.snapshots(),
                  builder: (context,snapshot){
                    if(!snapshot.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }else{
                      int oldChat=0,snap=0;
                      if(_oldChatList!=null){
                        oldChat=_oldChatList.length;
                      }

                      if(snapshot.data.docs!=null){
                        snap=snapshot.data.docs.length;
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: oldChat+snap,
                        itemBuilder: (context,i){
                          String roomId;
                          if(i<oldChat){

                          }
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(""),
                            ),
                            title: Text("room"),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            );
          }else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
