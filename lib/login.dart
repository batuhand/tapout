import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapout/home_page.dart';

import 'home_page.dart';

class Login extends StatefulWidget{
  static String tag = "login-page";
  @override
  _LoginState createState() => new _LoginState();

}

class _LoginState extends State<Login>{
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context){

    final username = TextFormField(
      controller: usernameController,
      keyboardType: TextInputType.text,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Username",
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );

    final password = TextFormField(
      controller: passwordController,
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: "Password",
        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
      ),
    );

    final loginButton=Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: (){
            loginControl();
        },
        padding: EdgeInsets.all(12),
        color: Colors.red,
        child: Text("Login",style: TextStyle(color: Colors.white)),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24,right: 24),
          children: <Widget>[
            username,
            password,
            loginButton
          ],
        ),
      ),
    );
  
  }

  loginControl(){
    Navigator.push(context,MaterialPageRoute(
    builder: (context) =>
     new HomePage(username : usernameController.text.toString()))
  );
  }

}