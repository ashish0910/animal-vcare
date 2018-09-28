import 'package:flutter/material.dart';
import 'package:vcareanimal/ui/login_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

final FirebaseStorage storage = new FirebaseStorage(storageBucket: 'gs://fir-flutter-a5069.appspot.com');

FirebaseUser user ;

void getuser() async {
  user = await FirebaseAuth.instance.currentUser();
  runApp(new MyApp());
}

void main() async {

  getuser();
  
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
    }
  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Vcareanimal',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
        primaryIconTheme: new IconThemeData(color: Colors.white)
         
      ),
      debugShowCheckedModeBanner: false,
      home: new LoginPage(user),
    );
  }
}

