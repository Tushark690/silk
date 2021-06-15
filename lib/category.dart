import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:transparent_image/transparent_image.dart';
class Category extends StatefulWidget {
  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  File _selectedImage;
  final picker = ImagePicker();
  TextEditingController _categoryName= TextEditingController();
  CollectionReference _categoryRef;
  firebase_storage.Reference ref;
  bool _savePressed=false;


  @override
  void initState() {
    super.initState();
    _categoryRef = FirebaseFirestore.instance.collection('category');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Category"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField( 
                controller: _categoryName,
                decoration: InputDecoration(
                  hintText: "Category Name"
                ),
              ),
              SizedBox(height: 10,),
              AspectRatio(
                aspectRatio: 1,
                child: _selectedImage==null?Container():Container(
                  margin: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(_selectedImage),
                          fit: BoxFit.cover)),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                      color: Colors.blue,
                      child: Text("Choose Image",style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        _chooseImage();
                      }),
                  RaisedButton(
                      color: Colors.red,
                      child: _savePressed? SizedBox(
                          height: 10,
                          width: 10,
                          child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),strokeWidth: 2,))
                          :Text("Save",style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        _uploadFile();
                      }),
                ],
              ),
              SizedBox(height: 20,),
              Text("Categories",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w500),),
              Container(width: MediaQuery.of(context).size.width*3/10,height: 8,color: Colors.blue,),
              StreamBuilder(
                stream: _categoryRef.snapshots(),
                builder: (context,snapshot){
                  return !snapshot.hasData?Center(child: CircularProgressIndicator(),)
                      : Container(padding: EdgeInsets.all(4),
                          child: snapshot.data.documents.length==0?Text("No Data",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800,color:Colors.grey),)
                        :GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,childAspectRatio: 0.8),
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Stack(
                                      children: [
                                        AspectRatio(
                                          aspectRatio: 1,
                                          child: Container(
                                            width: double.infinity,
                                            margin: EdgeInsets.all(3),
                                            child: FadeInImage.memoryNetwork(
                                                fit: BoxFit.cover,
                                                placeholder: kTransparentImage,
                                                image: snapshot.data.documents[index].get('url')),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: IconButton(
                                            icon: Icon(Icons.cancel),
                                            onPressed: (){
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  // return object of type Dialog
                                                  return AlertDialog(
                                                    title: new Text("Alert!!!"),
                                                    content: new Text("Are you sure"),
                                                    actions: <Widget>[
                                                      // usually buttons at the bottom of the dialog
                                                      new FlatButton(
                                                        child: new Text("Yes"),
                                                        onPressed: () {
                                                          snapshot.data.documents[index].reference.delete();
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                      new FlatButton(
                                                        child: new Text("No"),
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    Text(snapshot.data.documents[index].get('categoryName'),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),)
                                  ],
                                );
                              }),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,);
    setState(() {
      _selectedImage=File(pickedFile?.path);
    });
    if (pickedFile.path == null) _retrieveLostData();
  }

  Future<void> _retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _selectedImage=File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }

  Future _uploadFile() async {
      if(_savePressed){

      }else if(_categoryName.text.isEmpty){
        Fluttertoast.showToast(msg: "Please enter category name");
      }else if(_selectedImage==null){
        Fluttertoast.showToast(msg: "Please select Image");
      }else{
        setState(() {
          _savePressed=true;
        });
        ref = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('images/${Path.basename(_selectedImage.path)}');
        await ref.putFile(_selectedImage).whenComplete(() async {
          await ref.getDownloadURL().then((value) {
            _categoryRef.add({'url': value,'categoryName':_categoryName.text}).whenComplete(() {
              Fluttertoast.showToast(msg: "Saved");
              setState(() {
                _savePressed=false;
              });
            });
          });
        });
      }

  }
}
