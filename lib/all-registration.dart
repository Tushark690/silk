import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllRegistration extends StatefulWidget {
  @override
  _AllRegistrationState createState() => _AllRegistrationState();
}

class _AllRegistrationState extends State<AllRegistration> {
  
  CollectionReference _regs;
  
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
                            _headingRow("Address"),
                          ],
                        ),
                      ),
                      SizedBox(height: 5,),
                      ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                        primary: false,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context,i){
                          return Column(
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
                                      _cellRow(snapshot.data.documents[i].get('address'),i),
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
                        },
                      )
                    ],
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
}
