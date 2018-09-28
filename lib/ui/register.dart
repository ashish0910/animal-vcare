import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class RegisterPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RegisterPageState();
  }

}

class RegisterPageState extends State<RegisterPage>{
  

  final formKey1 = new GlobalKey<FormState>();
  String _email ;
  String _password ;
  String _error ;
  String _name ;
  String _id;
  

                        bool _validatelogin() {
                          final form  = formKey1.currentState;
                          if(form.validate()){
                            form.save();
                            return true;
                          }
                          else {
                            return false;
                          }
                      }
                       void _submit() async{
                         if(_validatelogin())
                         {
                           try {
                           FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email , password: _password);
                           
                           _id=user.uid;
                           final DocumentReference reference = Firestore.instance.collection("user").document(_id) ;
                               Map<String,dynamic> data = <String,dynamic>{
                                  "email" : _email,
                                  "id" : _id,
                                  "name" : _name ,
                                   };
                               reference.setData(data).whenComplete((){
                                  print("Document Added");
                                  print("Registered user : ${user.uid}");
                                  Navigator.of(context).pop();
                                      });        
                           
                           }
                           catch(e){
                             print("error : $e");
                             setState(() {
                                  _error="Email already taken or password is less than 6 characters";                          
                                                          });
                           }
                         }
                       }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Register",style: new TextStyle(color: Colors.white),),
      ),
      body: Center(
          child: new Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
             key: formKey1,
             child: new ListView(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Padding( padding: const EdgeInsets.only(top: 80.0), ),
                  new Icon(Icons.person_add,size: 150.0,color: Colors.orange,),
                  new TextFormField(
                    decoration: new InputDecoration(
                      hintText: "Enter your name",
                      icon: new Icon(Icons.person)
                    ),
                    validator: (value) => value.isEmpty ? 'Please Enter your name' : null,
                    onSaved: (value) => _name=value,
                  ),
                  new Padding( padding: const EdgeInsets.only(top: 20.0), ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      hintText: "Enter unique Email",
                      icon: new Icon(Icons.person)
                    ),
                    validator: (value) => value.isEmpty ? 'Please Enter your unique email' : null,
                    onSaved: (value) => _email=value,
                  ),
                  new Padding( padding: const EdgeInsets.only(top: 20.0), ),
                  new TextFormField(
                    decoration: new InputDecoration(
                      hintText: "Enter Password(at least 6 digits)",
                      icon: new Icon(Icons.vpn_key)
                    ),
                    obscureText: true,
                    validator: (value) => value.isEmpty ? 'Please Enter your password' : null,
                    onSaved: (value) => _password=value,
                  ),
                  new Padding( padding: const EdgeInsets.only(top: 20.0), ),
                  Center(
                    child: new MaterialButton(
                      color: Colors.orange,
                      child: new Text("Register",style: new TextStyle(color: Colors.white, fontSize: 20.0),), onPressed: _submit,
                    ),
                  ),
                  new Padding( padding: const EdgeInsets.only(top: 10.0), ),
                  new Center(
                    child: _error!=null ? new Text(_error) : new Container(),
                  )
                ],
              ),
            ),
          ),
        ),
    );
  }

}