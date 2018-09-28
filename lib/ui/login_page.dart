import 'dart:async';
import 'package:flutter/material.dart';
import 'package:vcareanimal/ui/guest_home.dart';
import 'package:vcareanimal/ui/home.dart';
import 'package:vcareanimal/ui/register.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  FirebaseUser cuser ;
  LoginPage(this.cuser);
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState(cuser);
  }
}



class LoginPageState extends State<LoginPage> {
  FirebaseUser cuser;
  LoginPageState(this.cuser);
  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Exit App?"),
              actions: <Widget>[
                FlatButton(
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
                FlatButton(
                  child: Text("Yes"),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ],
            ));
  }

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      checkcurrentuser(cuser);
    }

  void checkcurrentuser (FirebaseUser  user){
  if(user!=null){
    print("SIgned in : ${user.email}");
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new Home(user)));
  } else print("problem");
}


  final formKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _error;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: new Scaffold(
          body: Center(
        child: new Container(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: new ListView(
              // crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 80.0),
                ),
                new Icon(
                  Icons.person,
                  size: 150.0,
                  color: Colors.orange,
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                      hintText: "Enter Email", icon: new Icon(Icons.person)),
                  validator: (value) =>
                      value.isEmpty ? 'Please Enter your email' : null,
                  onSaved: (value) => _email = value,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                new TextFormField(
                  decoration: new InputDecoration(
                      hintText: "Enter Password",
                      icon: new Icon(Icons.vpn_key)),
                  obscureText: true,
                  validator: (value) =>
                      value.isEmpty ? 'Please Enter your password' : null,
                  onSaved: (value) => _password = value,
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                Center(
                  child: new MaterialButton(
                    color: Colors.orange,
                    child: new Text(
                      "Login",
                      style: new TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: _submit,
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                ),
                new Center(
                  child: _error != null ? new Text(_error) : new Container(),
                ),
                new Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                ),
                Center(child: new Text("New user?")),
                new MaterialButton(
                  child: new Text(
                    "Register",
                    style: new TextStyle(color: Colors.orange),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context) => new RegisterPage()));
                  },
                ),
                new MaterialButton(
                  child: new Text(
                    "Continue As Guest user",
                    style: new TextStyle(color: Colors.orange),
                  ),
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new Guesthome() ));
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _submit() async {
    if (_validatelogin()) {
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        print("SIgned in : ${user.email}");
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new Home(user)));
      } catch (e) {
        print("error : $e");
        setState(() {
          _error = "Invalid Email or Password";
        });
      }
    }
  }

  bool _validatelogin() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }
}
