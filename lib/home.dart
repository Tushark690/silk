
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:highlighter_coachmark/highlighter_coachmark.dart';
import 'package:jewellery_admin/add-rates.dart';
import 'package:jewellery_admin/add_gallery.dart';
import 'package:jewellery_admin/all-registration.dart';
import 'package:jewellery_admin/contact-us.dart';
import 'package:jewellery_admin/custom-notification.dart';
import 'package:jewellery_admin/message1.dart';
import 'package:jewellery_admin/message2.dart';
import 'package:jewellery_admin/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'add-banner.dart';
import 'add-banner.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  GlobalKey _fabKey = GlobalObjectKey("fab");
  GlobalKey _message1Key = GlobalObjectKey("message1");
  GlobalKey _message2Key = GlobalObjectKey("message2");
  GlobalKey _rateKey = GlobalObjectKey("rate");
  GlobalKey _bannerKey = GlobalObjectKey("banner");
  GlobalKey _galleryKey = GlobalObjectKey("gallery");



  void _showMessage1() {
    CoachMark coachMarkTile = CoachMark();
    RenderBox target = _message1Key.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    coachMarkTile.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        markShape: BoxShape.rectangle,
        children: [
          Positioned(
              top: markRect.bottom + 15.0,
              right: 5.0,
              child: Text("Tap this to add message",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: Duration(seconds: 5),onClose: (){
      _showMessage2();
    });
  }

  void _showMessage2() {
    CoachMark coachMarkTile = CoachMark();
    RenderBox target = _message2Key.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    coachMarkTile.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        markShape: BoxShape.rectangle,
        children: [
          Positioned(
              top: markRect.bottom + 15.0,
              right: 5.0,
              child: Text("Tap this to add second message",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: Duration(seconds: 5),onClose: (){
      _showRates();
    });
  }

  void _showRates() {
    CoachMark coachMarkTile = CoachMark();
    RenderBox target = _rateKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    coachMarkTile.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        markShape: BoxShape.rectangle,
        children: [
          Positioned(
              top: markRect.bottom + 15.0,
              right: 5.0,
              child: Text("Tap this to update rate and send notification",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: Duration(seconds: 5),onClose: (){
      _showBanner();
    });
  }

  void _showBanner() {
    CoachMark coachMarkTile = CoachMark();
    RenderBox target = _bannerKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    coachMarkTile.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        markShape: BoxShape.rectangle,
        children: [
          Positioned(
              top: markRect.bottom + 15.0,
              right: 5.0,
              child: Text("Tap this to add banners",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: Duration(seconds: 5),onClose: (){
      _showGallery();
    });
  }

  void _showGallery() {
    CoachMark coachMarkTile = CoachMark();
    RenderBox target = _galleryKey.currentContext.findRenderObject();

    Rect markRect = target.localToGlobal(Offset.zero) & target.size;
    markRect = markRect.inflate(5.0);

    coachMarkTile.show(
        targetContext: _fabKey.currentContext,
        markRect: markRect,
        markShape: BoxShape.rectangle,
        children: [
          Positioned(
              top: markRect.bottom + 15.0,
              right: 5.0,
              child: Text("Tap this to add jewellery photos",
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                  )))
        ],
        duration: Duration(seconds: 5),onClose: (){

    });
  }

  @override
  void initState() {
    if (!kIsWeb) {
      _showTutorial();
    }
    super.initState();
  }

  _showTutorial()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    if(sp.getString("tutorial")!="done"){
      Timer(Duration(seconds: 1), (){
        _showMessage1();
        _initiateSP();
      });

    }
  }

  _initiateSP()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setString("tutorial", "done");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _fabKey,
      appBar: AppBar(title: Text('Home Page'),actions: [
        CupertinoButton(child: Text("Logout",style: TextStyle(color: Colors.white),), onPressed: ()async{
          SharedPreferences sp = await SharedPreferences.getInstance();
          sp.clear();
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignUpPage(),), (route) => false);
        })
      ],),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: AssetImage("assets/images/source.gif")
          )
        ),
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    key: _message1Key,
                    height: 80.0,
                    minWidth: 70.0,
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("Message 1",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Message1(),))
                    },
                    splashColor: Colors.redAccent,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    key: _message2Key,
                    height: 80.0,
                    minWidth: 70.0,
                    color: Colors.redAccent,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.message,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("Message 2",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Message2(),))
                    },
                    splashColor: Colors.yellowAccent,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    key: _rateKey,
                    height: 80.0,
                    minWidth: 70.0,
                    color: Colors.purpleAccent,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.monetization_on,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("Update Rate",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => AddRates()))
                    },
                    splashColor: Colors.lightGreenAccent,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    key: _bannerKey,
                    height: 80.0,
                    minWidth: 70.0,
                    color: Colors.green,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.comment_bank,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("Add Banner",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) => AddBanner()))
                    },
                    splashColor: Colors.amberAccent,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    key: _galleryKey,
                    height: 80.0,
                    minWidth: 70.0,
                    color: Colors.blueGrey,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.photo,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("Add Gallery",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => AddGallery()))
                    },
                    splashColor: Colors.orange,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    height: 80.0,
                    minWidth: 70.0,
                    color: Colors.teal,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.app_registration,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("All Registrations",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => AllRegistration()))
                    },
                    splashColor: Colors.orange,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    height: 80.0,
                    minWidth: 70.0,
                    color: Colors.pinkAccent,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.app_registration,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("Contacts",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => ContactUs()))
                    },
                    splashColor: Colors.orange,
                  ))
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(child:  MaterialButton(
                    height: 80.0,
                    minWidth: 70.0,
                    color: Colors.lime,
                    textColor: Colors.white,
                    shape: StadiumBorder(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.app_registration,size: 30,color: Colors.white,),
                        SizedBox(
                          width: 5,
                        ),
                        new Text("Custom Notification",style: TextStyle(fontSize: 30))
                      ],
                    ),
                    onPressed: () => {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => CustomNotification()))
                    },
                    splashColor: Colors.orange,
                  ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


}
