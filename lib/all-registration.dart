import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_admin/chat.dart';

class AllRegistration extends StatefulWidget {
  @override
  _AllRegistrationState createState() => _AllRegistrationState();
}

class _AllRegistrationState extends State<AllRegistration> {
  
  CollectionReference _regs;
  int _totalNewMess=0;
  QuerySnapshot _tMessRef;
  @override
  void initState() {
    _regs=FirebaseFirestore.instance.collection("register");
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Registration"),
      ),
      body: Container(
        child: StreamBuilder(
          stream: _regs.snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else{
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(

                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black45),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(width: MediaQuery.of(context).size.width*1/10,child: Text("Sno",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                              _headingRow("Name"),
                              _headingRow("Company"),
                              _headingRow("Mobile"),
                              _headingRow("Chat"),
                            ],
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: ReorderableListView(
                            onReorder: (oldIndex,newIndex){
                                    if(newIndex>oldIndex){
                                      newIndex-=1;
                                    }
                            },
                            children: List.generate(snapshot.data.docs.length, (i) {
                              return Column(
                                key: ValueKey("$i"),
                                children: [
                                  InkWell(
                                    onTap: (){

                                    },
                                    child: Container(
                                      color: i%2==0?Colors.grey:Colors.white,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(width: MediaQuery.of(context).size.width*1/10,child: Text((i+1).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),),
                                          _cellRow(snapshot.data.documents[i].get('name'),i),
                                          _cellRow(snapshot.data.documents[i].get('company'),i),
                                          _cellRow(snapshot.data.documents[i].get('mobile'),i),
                                          Container(
                                            padding: EdgeInsets.all(10),
                                            width: MediaQuery.of(context).size.width*2/10,
                                            child: Stack(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.chat,color: Colors.blue,),
                                                  onPressed: (){
                                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(snapshot.data.documents[i].get('mobile')),));
                                                  },
                                                ),
                                                StreamBuilder(
                                                  // future: _getTotalUnreadMessage(snapshot.data.documents[i].get('mobile')),
                                                  stream:FirebaseFirestore.instance.collection("chats")
                                                      .where("roomId",isEqualTo: snapshot.data.documents[i].get('mobile'))
                                                      .where("status",isEqualTo: "new")
                                                      .where("rec",isEqualTo: "admin").snapshots(),
                                                  builder: (context, snap) {
                                                    if(!snap.hasData){
                                                      return Center(
                                                        child: CircularProgressIndicator(),
                                                      );
                                                    }
                                                    return Positioned(
                                                      left: 0,
                                                      child: CircleAvatar(
                                                        radius: 10,
                                                        backgroundColor: Colors.red,
                                                        child: Text(snap.data.docs.length.toString())),);
                                                    // if(snap.connectionState==ConnectionState.done){
                                                    //   return Positioned(child: Text(_totalNewMess.toString()),right: 0,);
                                                    // }else{
                                                    //   return Center(
                                                    //     child: CircularProgressIndicator(),
                                                    //   );
                                                    // }
                                                  },
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    color: Colors.black,
                                    height: 1,
                                  )
                                ],
                              );
                            }),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _headingRow(value){
    return Container(
      width: MediaQuery.of(context).size.width*2/10,
      child: Text(value,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
    );
  }

  Widget _cellRow(value,i){
    return Container(
      padding: EdgeInsets.all(10),
      width: MediaQuery.of(context).size.width*2/10,
      child: Text(value),
    );
  }

  _getTotalUnreadMessage(roomId)async{
    try{
      _tMessRef = await FirebaseFirestore.instance.collection("chats")
          .where("roomId",isEqualTo: roomId)
          .where("status",isEqualTo: "new")
          .where("rec",isEqualTo: "admin").get();
      // _totalNewMess=snapshot.docs.length;
    }catch(e){

    }
  }
}
