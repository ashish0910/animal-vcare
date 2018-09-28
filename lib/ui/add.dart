import 'dart:io';
import 'package:location/location.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math';
import 'package:image_picker/image_picker.dart';


var api_key = "AIzaSyCmkGQq9xB7Tp2oetbbMJiqeZFEokiPqDY";
var currentLocation = <String, double>{};
var lat,lang;
var location = new Location();
Uri imguri;
var imgname ;
var url;

class AddPost extends StatefulWidget {
  FirebaseUser user;
  AddPost(this.user);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new AddPostState(user);
  }

}

class AddPostState extends State<AddPost>{
  FirebaseUser user;
  File image;
  
  String _id,_email ;
  String _animal,_description ;
  DateTime _date ;
  DocumentReference reference = Firestore.instance.collection("post").document();
  void picker(int c) async{
    print("picker called");
    File img;
    if(c==1){
      img = await ImagePicker.pickImage(source: ImageSource.gallery);
    }
    else if(c==2){
      img = await ImagePicker.pickImage(source: ImageSource.camera);
    }
    if(img!=null){
      print(img.path);
      image=img;
      if(image!=null){
       imageadder();
         }
    }
  }
  void imageadder() async{
    final String rand1 = "${new Random().nextInt(10000)}";
    final String rand2 = "${new Random().nextInt(10000)}";
    final String rand3 = "${new Random().nextInt(10000)}";
    imgname='${rand1}_${rand2}_${rand3}.jpg';
    final StorageReference reference = FirebaseStorage.instance.ref().child(imgname);
    final StorageUploadTask uploadTask = reference.putFile(image);
    final Uri downloadUrl = (await uploadTask.future).downloadUrl;
    imguri=downloadUrl;
    url=imguri.toString();
    print(imguri);
    setState(() {});
  }
  void _add(DateTime d,String id,String email,String animal,String description) {
    Map<String,dynamic> data = <String,dynamic>{
      "id" : id,
      "email" : email,
      "animal" : animal,
      "description" : description,
      "date" : d,
      "location" : currentLocation,
      "imagename" : imgname,
      "url" : url
    };
    reference.setData(data).whenComplete((){ print("Animal helped"); });
  }
  void _loc() async{
    try{
        currentLocation = await location.getLocation() ;
       
        lat=currentLocation['latitude'];
        lang=currentLocation['longitude'];
//         location.onLocationChanged.listen((Map<String,double> currentLocation) {
//       setState(() {
//         lat=currentLocation['latitude'];
//         lang=currentLocation['longitude'];      
//             });
// });

      }
      on PlatformException {
        currentLocation = null ;
        print("panga");
      }
  }

  AddPostState(this.user);
  final formKey = new GlobalKey<FormState>();
  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      _id = user.uid ;
      _email = user.email ;
      _loc();      

    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    
                return new Scaffold(
                  appBar: new AppBar(title: new Text("Enter details",style: new TextStyle(color: Colors.white),),),
                  floatingActionButton: new FloatingActionButton(
                    onPressed: (){
                      picker(2);
                    },
                    child: new Icon(Icons.camera_alt,color: Colors.white,),
                  ),
                  body: new Center(
                    child: new Container(
                      padding: const EdgeInsets.all(20.0),
                      child: new Form(
                        key: formKey,
                        child: new ListView(
                          children: <Widget>[
                            new TextFormField(
                                decoration: new InputDecoration(
                                  hintText: "Ex. Cow,Dog etc.",
                                  labelText: "Enter Animal",
                                ),
                                validator: (value) => value.isEmpty ? 'Please Enter animal' : null,
                                onSaved: (value) => _animal=value,
                              ),
                              new TextFormField(
                                decoration: new InputDecoration(
                                  labelText: "Enter description",
                                ),
                                validator: (value) => value.isEmpty ? 'Please Enter description' : null,
                                onSaved: (value) => _description=value,
                                maxLines: 5,
                              ),
                              new Padding( padding: const EdgeInsets.only(top: 20.0), ),
                              new MaterialButton(
                                    child: new Text("add image from gallery",style: new TextStyle(color: Colors.white)),
                                    color: Colors.orange,
                                    onPressed: (){
                                      picker(1);
                                    },                                    
                                  ),
                  new Padding( padding: const EdgeInsets.only(top: 20.0), ),
                   (image!=null)&&(imguri==null) ? new Text("Uploading image , Do not press any button please wait...") :  
                    new Container(
                      child: new MaterialButton(
                      child: new Text("Help animal",style: new TextStyle(color: Colors.white),),
                      color: Colors.orange,
                      onPressed: () {
                        _date = DateTime.now();
                        
                        final form = formKey.currentState ;
                        if(form.validate()){
                          form.save();
                          _add(_date,_id,_email,_animal,_description);
                        print("$_animal $_description");
                        lat=currentLocation['latitude'];
                        lang=currentLocation['longitude'];
                        
                        Navigator.of(context).pop(context);
                        }
                      },
                    ),
                  ) ,
                  new Padding( padding: const EdgeInsets.only(top: 20.0), ),
                  
              ],
            ),
          ),
        ),
      ),
    );
  }

}

