
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:transparent_image/transparent_image.dart';

class AddGallery extends StatefulWidget {
  @override
  _AddGalleryState createState() => _AddGalleryState();
}

class _AddGalleryState extends State<AddGallery> {
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;

  List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Gallery'),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() {
                    setState(() {
                      _image=[];
                      uploading=false;
                    });
                  });
                },
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(4),
                    child: GridView.builder(
                        itemCount: _image.length + 1,
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          return index == 0
                              ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                !uploading ? chooseImage() : null),
                          )
                              : Stack(
                                children: [
                                  Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_image[index - 1]),
                                        fit: BoxFit.cover)),
                          ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: Icon(Icons.cancel),
                                      onPressed: (){
                                        setState(() {
                                          _image.removeAt(index-1);
                                        });
                                      },
                                    ),
                                  )
                                ],
                              );
                        }),
                  ),
                  StreamBuilder(
                    stream: imgRef.snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                        child: CircularProgressIndicator(),
                      )
                          : Container(
                        padding: EdgeInsets.all(4),
                        child: snapshot.data.documents.length==0?Center(
                          child: Text("No Data",style: TextStyle(fontSize: 24,fontWeight: FontWeight.w800,color:Colors.grey),),
                        ):GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data.documents.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              return Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.all(3),
                                    child: FadeInImage.memoryNetwork(
                                        fit: BoxFit.cover,
                                        placeholder: kTransparentImage,
                                        image: snapshot.data.documents[index].get('url')),
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
                              );
                            }),
                      );
                    },
                  ),
                ],
              ),
            ),
            uploading
                ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text(
                        'uploading...',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CircularProgressIndicator(
                      value: val,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                  ],
                ))
                : Container(),
          ],
        ));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('gallery');
  }
}