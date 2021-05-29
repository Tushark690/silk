import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:jewellery_admin/constant.dart';

class AddRates extends StatefulWidget {
  @override
  _AddRatesState createState() => _AddRatesState();
}

class _AddRatesState extends State<AddRates> {

  TextEditingController _name;
  TextEditingController _rate;
  TextEditingController _serial;
  CollectionReference rateRef;
  String message="Bhav updated for : ";

  @override
  void initState() {
    _name=TextEditingController();
    _rate=TextEditingController();
    _serial=TextEditingController();
    rateRef = FirebaseFirestore.instance.collection('rate');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Rates"),
        actions: [
          Container(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              child: Text("Send Notification"),
              onPressed: (){
                _sendNotification();
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) => Colors.green)
              ),
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                decoration: new InputDecoration(
                  labelText: "Enter Name",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.words
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _rate,
                decoration: new InputDecoration(
                  labelText: "Enter rate",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 20,),
              TextFormField(
                controller: _serial,
                decoration: new InputDecoration(
                  labelText: "Enter Serial for Icon",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.sentences,
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape: MaterialStateProperty.resolveWith((states) => StadiumBorder())
                      ),
                      child: Text("Add"),
                      onPressed: (){
                        _addRate();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("All rates",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: rateRef.snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : Container(
                    padding: EdgeInsets.all(4),
                    child:snapshot.data.documents.length==0?Center(
                      child: Text("No Data",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800,color:Colors.grey),),
                    ): ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {

                          return InkWell(
                            onTap: (){

                            },
                            child: Card(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(child: Text(snapshot.data.documents[index].get('serial') ,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600))),
                                      Expanded(
                                          child:
                                          // ! _checkTap[snapshot.data.documents[index].reference.id]?
                                          Text(snapshot.data.documents[index].get('name'),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                                        // TextFormField(
                                        //   controller: _updateMessage[index],
                                        // ),
                                      ),
                                      Expanded(
                                          child:
                                          // ! _checkTap[snapshot.data.documents[index].reference.id]?
                                          Text(snapshot.data.documents[index].get('rate'),style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                                        // TextFormField(
                                        //   controller: _updateMessage[index],
                                        // ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: (){
                                            _updateRate(snapshot.data.documents[index].reference,snapshot.data.documents[index].get('rate'),snapshot.data.documents[index].get('name'));
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.restore_from_trash_outlined),
                                        onPressed: (){
                                          snapshot.data.documents[index].reference.delete();
                                        },
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          );
                        }),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _addRate()async{
    if(_name.text.trim().length<1){
      Fluttertoast.showToast(msg: "Please enter name");
    }else if(_rate.text.trim().length<1){
      Fluttertoast.showToast(msg: "Please enter rate");
    }else if(_serial.text.trim()!="1" && _serial.text.trim()!="2" && _serial.text.trim()!="3" && _serial.text.trim()!="4"){
      Fluttertoast.showToast(msg: "Serial Should be in range of 1 to 4");
    }else{
       final DateTime now = DateTime.now();
       final DateFormat formatter = DateFormat('dd MMM, yyyy, hh:mm a');
      final String formatted = formatter.format(now);
      rateRef.add({
        "name":_name.text,
        "rate":_rate.text,
        "serial":_serial.text,
        "updatedTime":formatted
      }).whenComplete(() {
        _name.text="";
        _rate.text="";
        Fluttertoast.showToast(msg: "Saved");
      });
    }
  }

  _updateRate(data,rate,name){
    TextEditingController t1= TextEditingController();
    t1.text=rate;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(name),
          content: TextFormField(
            controller: t1,
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("No"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Update"),
              onPressed: () {
                final DateTime now = DateTime.now();
                final DateFormat formatter = DateFormat('dd MMM, yyyy, hh:mm a');
                final String formatted = formatter.format(now);
                data.updateData({"rate":t1.text,
                "updatedTime":formatted});
                Navigator.of(context).pop();
                Fluttertoast.showToast(msg: "Updated successfully");
              },
            ),
          ],
        );
      },
    );
  }

  _sendNotification()async{
    try {
      message="Bhav updated for : ";
      rateRef.get().then((QuerySnapshot snapshot)  {
        snapshot.docs.forEach((f) {
          print("1111");
          message=message+f.get('name')+" : "+f.get('rate')+ "\n";
        });
      }).whenComplete(()async {
        var url = 'https://fcm.googleapis.com/fcm/send';
        var header = {
          "Content-Type": "application/json",
          "Authorization":
          "key=$key",
        };
        print(message);
        var request = {
          "notification" : null,
          "data": {
            "title": firmName,
            "body": message,
            "music": "bhavupdate",
            "msgId" : 1,
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
            "title": firmName,
            "body": message,
            "sound": "bhavupdate.aiff",
            "msgId" : 1,
          },
          "data" : null,
          "priority": "high"
        };

        var client1 = new Client();
        var response1 =
            await client1.post(url, headers: header, body: jsonEncode(request1));
        Fluttertoast.showToast(msg: "Notification Send");
        return true;
      });


    } catch (e, s) {
      print(e);
      return false;
    }
  }
}
