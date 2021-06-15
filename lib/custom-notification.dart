import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:jewellery_admin/constant.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomNotification extends StatefulWidget {
  @override
  _CustomNotificationState createState() => _CustomNotificationState();
}

class _CustomNotificationState extends State<CustomNotification> {

  TextEditingController _title=TextEditingController();
  TextEditingController _body=TextEditingController();
  TextEditingController _speechrate=TextEditingController(text: "0.7");
  TextEditingController _volume=TextEditingController(text: "1.0");
  TextEditingController _pitch=TextEditingController(text: "1.0");
  FlutterTts flutterTts = FlutterTts();
  String _selectedLang="hi-IN";
  String _selectedVoice="hi-in-x-hia-local";
  List<DropdownMenuItem> _languageList =[];
  List<DropdownMenuItem> _voiceList =[];
  Query _cp=FirebaseFirestore.instance.collection("savedVoices").orderBy("dateTime",descending: true);


  @override
  void initState() {
    flutterTts.getLanguages.then((value) {
      for(var a in value){
       setState(() {
         _languageList.add(DropdownMenuItem(child: Text(a),value: a,));
       });
      }
    });

    flutterTts.getVoices.then((value) {
      for(var a in value){
        setState(() {
          _voiceList.add(DropdownMenuItem(child: Text(a),value: a,));
        });
      }
    });
    super.initState();
  }

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
                children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black45)
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            hint: Text("Please select"),
                            decoration: InputDecoration(
                              disabledBorder: InputBorder.none,
                              border: InputBorder.none,
                            ),
                            elevation: 0,
                            value: _selectedLang,
                            items: _languageList,
                            onChanged: (value){
                              setState(() {
                                _selectedLang=value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(color: Colors.black45)
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          hint: Text("Please select"),
                          decoration: InputDecoration(
                            disabledBorder: InputBorder.none,
                            border: InputBorder.none,
                          ),
                          elevation: 0,
                          value: _selectedVoice,
                          items: _voiceList,
                          onChanged: (value){
                            setState(() {
                              _selectedVoice=value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _volume,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: "Enter Volume",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),),
                  SizedBox(width: 10,),
                  Expanded(child: TextFormField(
                    controller: _pitch,
                    keyboardType: TextInputType.number,
                    decoration: new InputDecoration(
                      labelText: "Enter Pitch",
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(25.0),
                        borderSide: new BorderSide(
                        ),
                      ),
                      //fillColor: Colors.green
                    ),
                  ),),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _speechrate,
                      keyboardType: TextInputType.number,
                      decoration: new InputDecoration(
                        labelText: "Enter Speech Rate",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
                    ),
                  )
                ],
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
              ),
              SizedBox(height: 20,),
              Text("Send notification",style: TextStyle(fontSize: 30,fontWeight: FontWeight.w800),),
              StreamBuilder(
                stream: _cp.snapshots(),
                builder: (context, snapshot) {
                  if(!snapshot.hasData){
                    return Center(child: SingleChildScrollView());
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(child: Text("Language : "+snapshot.data.docs[index].get("language"),style: TextStyle(fontSize: 18),)),
                                  Expanded(child: Text("Voice : "+snapshot.data.docs[index].get("voice"),style: TextStyle(fontSize: 18),)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text("Volume : "+snapshot.data.docs[index].get("volume"),style: TextStyle(fontSize: 18),)),
                                  Expanded(child: Text("Pitch : "+snapshot.data.docs[index].get("pitch"),style: TextStyle(fontSize: 18),)),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text("Speech Rate : "+snapshot.data.docs[index].get("volume"),style: TextStyle(fontSize: 18),)),
                                  GestureDetector(
                                    onTap: (){
                                        _play(snapshot.data.docs[index]);
                                    },
                                      child: Expanded(child: Text("Play",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w800,color: Colors.blue),)))
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(child: Text(snapshot.data.docs[index].get("dateTime").toString()))
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
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
    }else if(_selectedLang.length<1){
      Fluttertoast.showToast(msg: "Please select language");
    }else if(_speechrate.text.length<1){
      Fluttertoast.showToast(msg: "Please enter speech rate");
    }else if(double.parse(_speechrate.text)>1){
      Fluttertoast.showToast(msg: "Speech rate should be less than or equal to 1");
    }else if(_volume.text.length<1){
      Fluttertoast.showToast(msg: "Please enter volume");
    }else if(double.parse(_volume.text)>1){
      Fluttertoast.showToast(msg: "Volume should be less than or equal to 1");
    }else if(_pitch.text.length<1){
      Fluttertoast.showToast(msg: "Please enter pitch");
    }else{
      _sendNotification();
      _saveDataTOSP();
    }
  }

  _saveDataTOSP()async{
    FirebaseFirestore.instance.collection("savedVoices").add({
      "message":_body.text,
      "language":_selectedLang,
      "voice":_selectedVoice,
      "volume":_volume.text,
      "pitch":_pitch.text,
      "speechRate":_speechrate.text,
      "dateTime":DateTime.now().toString()
    });
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
          "language":_selectedLang,
          "voice":_selectedVoice,
          "volume":_volume.text,
          "pitch":_pitch.text,
          "srate":_speechrate.text
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
    if(_body.text.trim().length<1){
      Fluttertoast.showToast(msg: "Please enter message body");
    }else if(_selectedLang.length<1){
      Fluttertoast.showToast(msg: "Please select language");
    }else if(_speechrate.text.length<1){
      Fluttertoast.showToast(msg: "Please enter speech rate");
    }else if(double.parse(_speechrate.text)>1){
      Fluttertoast.showToast(msg: "Speech rate should be less than or equal to 1");
    }else if(_volume.text.length<1){
      Fluttertoast.showToast(msg: "Please enter volume");
    }else if(double.parse(_volume.text)>1){
      Fluttertoast.showToast(msg: "Volume should be less than or equal to 1");
    }else if(_pitch.text.length<1){
      Fluttertoast.showToast(msg: "Please enter pitch");
    }else{
      flutterTts.setLanguage(_selectedLang);
      flutterTts.setSpeechRate(double.parse(_speechrate.text));
      flutterTts.setVolume(double.parse(_volume.text));
      flutterTts.setPitch(double.parse(_pitch.text));
      flutterTts.setVoice(_selectedVoice);
      flutterTts.speak(_body.text);

    }
  }

  _play(data){
    flutterTts.setLanguage(data.get("language"));
    flutterTts.setSpeechRate(double.parse(data.get("speechRate")));
    flutterTts.setVolume(double.parse(data.get("volume")));
    flutterTts.setPitch(double.parse(data.get("pitch")));
    flutterTts.setVoice(data.get("voice"));
    flutterTts.speak(data.get("message"));
  }
}
