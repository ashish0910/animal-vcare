import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyPosts extends StatefulWidget {
  FirebaseUser user;
  MyPosts(this.user);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new MyPostsState(user);
  }

}

class MyPostsState extends State<MyPosts>{
  FirebaseUser user;
  MyPostsState(this.user);
  final CollectionReference collectionReference = Firestore.instance.collection("post");
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar( title: new Text("My Posts",style: new TextStyle(color: Colors.white),),elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0:0.0 , ),
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
                if(document['animal']=="cow"||document['animal']=="Cow") img="cow.png"; else
                if(document['animal']=="insect"||document['animal']=="Insect") img="spider.png"; else
                if(document['animal']=="spider"||document['animal']=="Spider") img="spider.png"; else
                if(document['animal']=="bull"||document['animal']=="Bull") img="cow.png"; else                
                if(document['animal']=="rabbit"||document['animal']=="Rabbit") img="rabbit.png"; else
                if(document['animal']=="bird"||document['animal']=="Bird") img="bird.png"; else
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
                if(document['id']==user.uid)
                {
                  return Card(
                 child: new ListTile(
                  leading: new CircleAvatar(
                      child: new Image.asset('img/$img'),
                  ),
                  trailing: new IconButton( icon: new Icon(Icons.delete), onPressed: (){
                    showDialog(context: context,builder: (BuildContext context){
                      return new AlertDialog(
                        title: new Text("Delete"),
                        content: new Text("Are you sure?"),
                        actions: <Widget>[
                          new RaisedButton(
                          child: new Text("Cancel"),
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        ),
                        new RaisedButton(
                          child: new Text("Yes"),
                          onPressed: (){
                            DocumentReference documentReference = Firestore.instance.collection("post").document(document.documentID);
                            
                            if(document['imagename']!=null) 
                            { StorageReference storageReference = FirebaseStorage.instance.ref().child(document['imagename']);
                              storageReference.delete().whenComplete((){ print("image deleted"); });}
                            documentReference.delete().whenComplete((){
                              print("deleted");
                            });
                            Navigator.pop(context);
                          },
                        ),
                        ],
                      );
                    });
                  },),
                  title: new Text(document['animal']),
                   subtitle: new Text(document['description']),
              ),
                );
                }
              else
              return Container();
              
            },
          );
        },
      )
    );
  }

}