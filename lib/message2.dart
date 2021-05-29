import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Message2 extends StatefulWidget {
  @override
  _Message2State createState() => _Message2State();
}

class _Message2State extends State<Message2> {

  TextEditingController _message;
  CollectionReference messageRef;
  List<TextEditingController> _updateMessage=[];
  Map<String,dynamic> _checkTap=Map();

  @override
  void initState() {
    _message=TextEditingController();
    messageRef = FirebaseFirestore.instance.collection('message2');
    StreamBuilder(
        stream: messageRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return new Text('Loading...');
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              print(index);
              TextEditingController t1=TextEditingController();
              t1.text=snapshot.data.documents[index].get('message');
              _updateMessage.add(t1);
              _checkTap.update(snapshot.data.documents[index].reference.id, (value) => false,ifAbsent: () => false,);
              return Container();
            },
          );
        });


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Message 2"),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30,left: 10,right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              new TextFormField(
                controller: _message,
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
                        _addMessage();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text("All Messages",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: messageRef.snapshots(),
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
                              setState(() {
                                print(_checkTap[snapshot.data.documents[index].reference.id]);
                                _checkTap.update(snapshot.data.documents[index].reference.id, (value) => true,ifAbsent: () => true,);
                                print(_checkTap[snapshot.data.documents[index].reference.id]);
                              });
                            },
                            child: Card(
                              child: Container(
                                  padding: EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child:
                                          // ! _checkTap[snapshot.data.documents[index].reference.id]?
                                          Text(snapshot.data.documents[index].get('message'))
                                        // TextFormField(
                                        //   controller: _updateMessage[index],
                                        // ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.restore_from_trash_outlined),
                                        onPressed: (){
                                          snapshot.data.documents[index].reference.delete();
                                        },
                                      )
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

  _addMessage()async{
    if(_message.text.trim().length<1){
      Fluttertoast.showToast(msg: "Please add some message first");
    }else{
      messageRef.add({
        "message":_message.text
      }).whenComplete(() {
        Fluttertoast.showToast(msg: "Message added.");
        _message.text="";
      });
    }
  }
}
