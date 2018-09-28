import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:vcareanimal/main.dart';
import 'package:vcareanimal/ui/add.dart';
import 'package:vcareanimal/ui/login_page.dart';
import 'package:vcareanimal/ui/my_posts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:vcareanimal/ui/post.dart';
import 'package:vcareanimal/ui/requests.dart';


class Home extends StatefulWidget{
  FirebaseUser user;
  Home(this.user);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new HomeState(user);
  }

}

class HomeState extends State<Home>{
  FirebaseUser user;
  void _signout() async{
     await FirebaseAuth.instance.signOut();
     runApp(new MyApp());
  }
  final CollectionReference collectionReference = Firestore.instance.collection("post");
  HomeState(this.user);
  String _email="your email" ;
  String _id;
  String _name="your name" ;
  Future _namer() async{
    DocumentReference documentReference = Firestore.instance.collection("user").document(_id);
    documentReference.get().then((snapshot){  setState(() {
           _name=snapshot.data['name'];
        }); print(_name); });
  }
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _email = user.email ;
      _id = user.uid ;
      _namer();
    }
  
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Animal Vcare",style: new TextStyle(color: Colors.white),),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0:0.0 ,
      ),
      
      drawer: new Drawer(
         child: new ListView(
           children: <Widget>[
             UserAccountsDrawerHeader(
               accountEmail: new Text(_email,style: new TextStyle(color: Colors.white),),
               accountName: new Text(_name,style: new TextStyle(color: Colors.white)),
               currentAccountPicture: new CircleAvatar(
                 child: new Text("${_name[0]}${_name[1]}",style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0)),
                 backgroundColor: Colors.yellow,
                 foregroundColor: Colors.white,
               ),
             ),
             new ListTile( title: new Text("My Posts"), onTap: () {  Navigator.of(context).pop(context); Navigator.of(context).push(new MaterialPageRoute( builder: (BuildContext context) => new MyPosts(user) )); }, trailing: new Icon(Icons.account_box),),
             new ListTile( title: new Text("Add Post"), onTap: () { Navigator.of(context).pop(context); Navigator.of(context).push(new MaterialPageRoute(  builder: (BuildContext context) => new AddPost(user) )); } ,trailing: new Icon(Icons.add),),
             new ListTile( title: new Text("Requests"), onTap: () {  Navigator.of(context).pop(context); Navigator.of(context).push(new MaterialPageRoute( builder: (BuildContext context) => new Requests(user) )); }, trailing: new Icon(Icons.event_note),),
             new ListTile(  title: new Text("Sign out"), trailing:new Icon(Icons.exit_to_app) ,onTap : () {
                // Navigator.of(context).push( new MaterialPageRoute(builder: (BuildContext context) => new LoginPage()) ); 
                _signout();
                 }, ),
             
           ],
         ),
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return new Center(
              child: new Text("NO POSTS"),
            );
          }
          final int count = snapshot.data.documents.length ;
          String img;
          return new ListView.builder(
            itemCount: count,
            itemBuilder: (_,index){
              final DocumentSnapshot document = snapshot.data.documents[count-index-1];
                if(document['animal']=="cow"||document['animal']=="Cow"||document['animal']=="buffalo"||document['animal']=="Buffalo") img="cow.png"; else
                if(document['animal']=="insect"||document['animal']=="Insect") img="spider.png"; else
                if(document['animal']=="spider"||document['animal']=="Spider") img="spider.png"; else
                if(document['animal']=="bull"||document['animal']=="Bull") img="cow.png"; else                
                if(document['animal']=="rabbit"||document['animal']=="Rabbit") img="rabbit.png"; else
                if(document['animal']=="bird"||document['animal']=="Bird"||document['animal']=="pigeon"||document['animal']=="Pigeon"||document['animal']=="sparrow"||document['animal']=="Sparrow") img="bird.png"; else
                if(document['animal']=="turtle"||document['animal']=="Turtle") img="turtle.png"; else
                if(document['animal']=="parrot"||document['animal']=="Parrot") img="parrot.png"; else
                if(document['animal']=="dog"||document['animal']=="Dog") img="dog.png"; else
                if(document['animal']=="cat"||document['animal']=="Cat") img="cat.png"; else
                if(document['animal']=="rat"||document['animal']=="Rat") img="rat.png"; else
                if(document['animal']=="hamster"||document['animal']=="Hamster") img="hamster.png"; else
                if(document['animal']=="fish"||document['animal']=="Fish") img="fish.png"; else
                if(document['animal']=="flea"||document['animal']=="Flea") img="flea.png"; else
                if(document['animal']=="chick"||document['animal']=="Chick") img="chick.png"; else
                if(document['animal']=="Hen"||document['animal']=="hen") img="chick.png"; else
                if(document['animal']=="chicken"||document['animal']=="Chicken") img="chick.png"; else
                if(document['animal']=="snake"||document['animal']=="Snake") img="snake.png"; else{ img="ambulance.png" ; }
                
                return Card(
                 child: new ListTile(
                  leading: new CircleAvatar(
                      child: new Image.asset('img/$img'),
                  ),
                  title: new Text(document['animal']),
                   subtitle: new Text(document['description']),
                   onTap: (){
                     Navigator.of(context).push(new MaterialPageRoute(
                          builder: (BuildContext context) => new Post(document.documentID,_id)));
                   },
              ),
                );
              
              
            },
          );
        },
      )
    );
  }

}