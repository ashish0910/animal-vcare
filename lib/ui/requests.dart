import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

String myid;

class Requests extends StatefulWidget{
  FirebaseUser user;
  Requests(this.user);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new RequestsState(user);
  }

}

CollectionReference collectionReference = Firestore.instance.collection("request") ;

class RequestsState extends State<Requests>{
  FirebaseUser user;
  RequestsState(this.user);
  // Future userget(String from) async{

  // }
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      myid=user.uid;
    }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Requests",style: new TextStyle(color: Colors.white)),
        elevation: defaultTargetPlatform == TargetPlatform.android ? 5.0:0.0 ,
      ),
      body: new StreamBuilder<QuerySnapshot>(
        stream: collectionReference.snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if(!snapshot.hasData){
            return new Center(
              child: new Text("NO REQUESTS"),
            );
          }
          final int count = snapshot.data.documents.length ;
          
          return new ListView.builder(
            itemCount: count,
            itemBuilder: (_,index){
              final DocumentSnapshot document = snapshot.data.documents[count-index-1];
                if(document['to']==myid)
                { 
                  return new Card(
                    child: new ListTile(
                    title: new Text("${document['animal']}"),
                    subtitle: new Text("from: ${document['email']}\nResponse to post added by you\non:${document['posttime']}\n${document['request']}"),
                    trailing: new IconButton(icon: new Icon(Icons.delete),onPressed: (){
                            showDialog(context: context,builder: (BuildContext context){
                              return new AlertDialog(
                                title: new Text("Delete"),
                                content: new Text("Are you Sure?"),
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
                                      DocumentReference documentReference = Firestore.instance.collection("request").document(document.documentID);
                            documentReference.delete().whenComplete((){
                              print("deleted");
                            });
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            });
                            
                    },),
                    onTap: (){
                      showDialog(context: context,builder: (BuildContext context){
                        return AlertDialog(
                          title: new Text("Request"),
                          content: new Text("You can contact the requester using his Email provided or decline the request by pressing delete button"),
                          actions: <Widget>[
                            new MaterialButton(
                              child: new Text("ok"),
                              onPressed: (){ Navigator.of(context).pop(); },
                            )
                          ],
                        );
                      });
                    },   
                    ),
                  );
                }else{
                  return new Container();
                }
            },
          );
        },
      )
    );
  }
}