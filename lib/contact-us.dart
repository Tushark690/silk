import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {

  bool _isWhatsapp=false;
  bool _isPhone=false;
  TextEditingController _name= TextEditingController();
  TextEditingController _number= TextEditingController();
  CollectionReference contactRef;

  @override
  void initState() {
    contactRef = FirebaseFirestore.instance.collection('contactRef');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact Us"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child:SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
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
                maxLines: 1,
              ),
              SizedBox(height: 10,),
              TextFormField(
                controller: _number,
                decoration: new InputDecoration(
                  labelText: "Enter Number",
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(25.0),
                    borderSide: new BorderSide(
                    ),
                  ),
                  //fillColor: Colors.green
                ),
                keyboardType: TextInputType.numberWithOptions(),
                maxLines: 1,
              ),
              SizedBox(height: 10,),
              CheckboxListTile(
                title: Text("Is Available for whatsapp"),
                value: _isWhatsapp,
                onChanged: (value){
                  setState(() {
                    _isWhatsapp=value;
                  });
                },
              ),
              SizedBox(height: 10,),
              CheckboxListTile(
                title: Text("Is Available for calling"),
                value: _isPhone,
                onChanged: (value){
                  setState(() {
                    _isPhone=value;
                  });
                },
              ),
              SizedBox(height: 20,),
              RaisedButton(
                child: Text("Save",style: TextStyle(color: Colors.white),),
                color: Colors.blue,
                onPressed: (){
                  _save();
                },
              ),
              SizedBox(
                height: 30,
              ),
              Text("All Contacts",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,decoration: TextDecoration.underline),),
              SizedBox(
                height: 30,
              ),
              StreamBuilder(
                stream: contactRef.snapshots(),
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
                                // _checkTap.update(snapshot.data.documents[index].reference.id, (value) => true,ifAbsent: () => true,);
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
                                          Text(snapshot.data.documents[index].get('name'))
                                        // TextFormField(
                                        //   controller: _updateMessage[index],
                                        // ),
                                      ),
                                      Expanded(child: Text(snapshot.data.documents[index].get('number'))),
                                      Expanded(child: Text(snapshot.data.documents[index].get('isAvailableForWhatsapp').toString())),
                                      Expanded(child: Text(snapshot.data.documents[index].get('isAvailableForPhone').toString())),
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

  _save()async{
  contactRef.add({
    "name":_name.text,
    "number":_number.text,
    "isAvailableForWhatsapp":_isWhatsapp,
    "isAvailableForPhone":_isPhone
  }).whenComplete(() {
    Fluttertoast.showToast(msg: "Contact added.");
    _name.text="";
    _number.text="";
  });
  }
}
