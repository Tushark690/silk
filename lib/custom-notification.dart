import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:jewellery_admin/constant.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CustomNotification extends StatefulWidget {
  @override
  _CustomNotificationState createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification> {

  TextEditingController _title=TextEditingController();
  TextEditingController _body=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom Notification"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _title,
                decoration: new InputDecoration(
                  labelText: "Enter Title",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 1,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _body,
                decoration: new InputDecoration(
                  labelText: "Enter Message",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(onPressed: (){
                    sendNot();
                  },child: Text("Send",style: TextStyle(color: Colors.white),),color: Colors.blue,),
                  RaisedButton(onPressed: (){
                    _speak();
                  },child: Text("Speak",style: TextStyle(color: Colors.white),),color: Colors.red,)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  sendNot()async{
    if(_title.text.trim().length<1){
      Fluttertoast.showToast(msg: "Please enter title");
    }else if(_body.text.trim().length<1){
      Fluttertoast.showToast(msg: "Please enter notification body");
    }else{
      _sendNotification();
    }
  }

  _sendNotification()async{
    try {
      var url = 'https://fcm.googleapis.com/fcm/send';
      var header = {
        "Content-Type": "application/json",
        "Authorization":
        "key=$key",
      };
      var request = {
        "notification" : null,
        "data": {
          "title": _title.text,
          "body": _body.text,
          "music": "tts",
          "msgId" : 2,
        },
        "priority": "high",
        "to": "/topics/android",
      };

      var client = new Client();
      var response =
      await client.post(url, headers: header, body: jsonEncode(request));

      var request1 = {
        "to": "/topics/ios",
        "notification": {
          "title": _title.text,
          "body": _body.text,
          "sound": "tts",
          "msgId" : 2,
        },
        "data" : null,
        "priority": "high"
      };

      var client1 = new Client();
      var response1 =
      await client1.post(url, headers: header, body: jsonEncode(request1));
      Fluttertoast.showToast(msg: "Notification Send");
      return true;

    } catch (e, s) {
      print(e);
      return false;
    }
  }

  _speak()async{
    if(_body.text.trim().length>0){
      FlutterTts flutterTts = FlutterTts();
      flutterTts.setLanguage("en-IN");
      flutterTts.speak(_body.text);
    }
  }
}
