import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tapout/pages.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  static String tag = "login-page";
  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  final usernameController = new TextEditingController();
  final passwordController = new TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    final username = Theme(
      data: new ThemeData(
          primaryColor: Colors.red, primaryColorDark: Colors.redAccent),
      child: TextFormField(
        controller: usernameController,
        autofocus: false,
        decoration: InputDecoration(
          hintText: "Username",
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        ),
      ),
    );

    final password = Theme(
      data: new ThemeData(
          primaryColor: Colors.red, primaryColorDark: Colors.redAccent),
      child: TextFormField(
        controller: passwordController,
        autofocus: false,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(32)),
        ),
      ),
    );

    final loginButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          login(usernameController.text, passwordController.text);
        },
        padding: EdgeInsets.all(12),
        color: Colors.red,
        child: Text("Login", style: TextStyle(color: Colors.white)),
      ),
    );

    final pad = SizedBox(
      height: 20,
      width: 50,
    );

    final errorMessage = Center(
      child: Text("$error"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            username,
            pad,
            password,
            loginButton,
            errorMessage
          ],
        ),
      ),
    );
  }

  login(String username, String password) async {
    String url = "https://tapoutapi.azurewebsites.net/api/user/";
    url = url + username;

    try {
      var response = await http.get(Uri.encodeFull(url));
      List result = json.decode(response.body);
      print(result[0]["password"].toString());
      String pass = result[0]["password"].toString();
      if (password == pass) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    new Pages(username: usernameController.text.toString())));
      } else {
        setState(() {
          error = "Wrong password";
        });
      }
      print(result);
    } catch (e) {
      setState(() {
        error = "Wrong username";
      });
    }
  }
}
