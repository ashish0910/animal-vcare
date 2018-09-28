import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

DateTime dateTime;
String _content;
String _email;
String _animal;
var _location;
var _image;
String url;
String to;
var stream;
var day,month,year,hour,minute;
var _help = new TextEditingController();
class Post extends StatefulWidget{
  String id;
  String from;
  Post(this.id,this.from);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new PostState(id,from);
  }

}
String did;
class PostState extends State<Post>{
  String _id;
  String _from;
  PostState(this._id,this._from);
  DocumentReference document = Firestore.instance.collection("post").document(did);
  Future _helper() async{
    DocumentReference ref = Firestore.instance.collection("request").document();
    Map<String,dynamic> data = <String,dynamic>{
                                  "to" : to,
                                  "postid" : _id,
                                  "from" :  _from,
                                  "request" : _help.text.toString(),
                                  "date" : DateTime.now(),
                                  "email" : _email,
                                  "animal" : _animal,
                                  "posttime" : "$day-$month-$year,$hour:$minute",
                                   };
                                   ref.setData(data).whenComplete((){
                                     print("request sent");
                                     Navigator.of(context).pop();
                                   });
  }
  Future poster() async {
      document.get().then((snapshot)async {
      print(snapshot.data['date']);
      print(snapshot.data['description']);
      setState(() {
      dateTime=snapshot.data['date'];
      day=dateTime.day;
      month=dateTime.month;
      year=dateTime.year;
      hour=dateTime.hour;
      minute=dateTime.minute;
      _content=snapshot.data['description'];
      _animal=snapshot.data['animal'];
      _location=snapshot.data['location'];
      to=snapshot.data['id'];
      _email=snapshot.data['email'];
      _image=snapshot.data['imagename'];
      url=snapshot.data['url'];      
            });
      print(url);
      print(to);
      print(_from);
    });
  }
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      did=_id;
      print(_id);
      poster();
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Details",style: new TextStyle(color: Colors.white)),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0:0.0 ,
      ),
      body: new ListView(
        padding: const EdgeInsets.all(20.0),
        children: <Widget>[
          _animal==null ? new Container() :new Text("$_animal",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0,color: Colors.grey),),
          new Padding(padding: const EdgeInsets.only(top: 20.0),),
          dateTime==null? new Container() : new Text("Added on:$day-$month-$year,$hour:$minute"),
          new Padding(padding: const EdgeInsets.only(top: 20.0),),
          _image==null ? new Container() : new Image.network(url),
          new Padding(padding: const EdgeInsets.only(top: 20.0),),
          _content==null? new Container() : new Text("$_content"),
          new Padding(padding: const EdgeInsets.only(top: 20.0),),
          _location!=null ? new Image.network(
            "https://maps.googleapis.com/maps/api/staticmap?center=${_location['latitude']},${_location["longitude"]}&zoom=18&size=640x400&key=AIzaSyCmkGQq9xB7Tp2oetbbMJiqeZFEokiPqDY") : new Center( child: new CircularProgressIndicator( backgroundColor: Colors.orange,), ),
          new Padding(padding: const EdgeInsets.only(top: 20.0),),
          to!=_from ? new Text("Want to help ? Enter your message for the publisher .") : new Container(),
          to!=_from ? new TextField(
             decoration: new InputDecoration(
               hintText: "Enter here.."
             ),
             maxLines: 6,
             controller: _help,
          ): new Container(),
          new Padding(padding: const EdgeInsets.only(top: 20.0),),
          to!=_from ?
          Container(
           child: new MaterialButton(
              child: new Text("Help animal"),
              color: Colors.orange,
              textColor: Colors.white,
              onPressed: (){
                if(_help.text.toString()!=""){
                  showDialog(context: context,builder: (BuildContext context){
                  return new AlertDialog(
                    title: new Text("Contact Publisher?"),
                    content: new Text("We are sending your details to publisher"),
                    actions: <Widget>[
                      new MaterialButton(
                        child: new Text("Cancel"),
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                      ),
                      new MaterialButton(
                        child: new Text("Yes"),
                        onPressed: (){
                          Navigator.of(context).pop();
                          _helper();
                        },
                      ),
                    ],
                  );
                });
                }
                
              },
            ),
          ):new Container(),  
        ],
      ),
    );
  }

}