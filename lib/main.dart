import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jewellery_admin/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  SharedPreferences sp;
  bool loginCheck=false;
  @override
  void initState() {
    check();
    super.initState();
  }

  check()async{
    sp=await SharedPreferences.getInstance();
    if(sp.getString("login")!=null){
      if(DateTime.parse(sp.getString("loginDate")).add(Duration(days: 1)).compareTo(DateTime.now())<1){
        sp.clear();
      }else {
        loginCheck = true;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return loginCheck?HomePage():SignUpPage();
  }
}
