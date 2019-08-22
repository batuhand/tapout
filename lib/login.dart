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
  final signUsername = new TextEditingController();
  final signPassword = new TextEditingController();
  final signEmail = new TextEditingController();
  String error = "";

  @override
  Widget build(BuildContext context) {
    final logo = new Container(
      child: Center(

        child: Padding(
          padding: EdgeInsets.all(30),
          child: Text(
          "tapout",
          style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontSize: 42),

        ),)
        
      ),
    );

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
      padding: EdgeInsets.fromLTRB(0, 16, 0, 0),
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

    final signupButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Form(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Theme(
                              data: new ThemeData(
                                  primaryColor: Colors.red,
                                  primaryColorDark: Colors.redAccent),
                              child: TextFormField(
                                controller: signUsername,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.red,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Username",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Theme(
                              data: new ThemeData(
                                  primaryColor: Colors.red,
                                  primaryColorDark: Colors.redAccent),
                              child: TextFormField(
                                controller: signEmail,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.red,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Theme(
                              data: new ThemeData(
                                  primaryColor: Colors.red,
                                  primaryColorDark: Colors.redAccent),
                              child: TextFormField(
                                controller: signPassword,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.red,
                                autofocus: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(32)),
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            color: Colors.redAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Text("Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () {
                              if (signUsername.text != null &&
                                  signPassword.text != null) {
                                signUp(
                                    signUsername.text.toString(),
                                    signEmail.text.toString(),
                                    signPassword.text.toString());
                                Navigator.pop(context);
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                );
              });
        },
        padding: EdgeInsets.all(12),
        color: Colors.red,
        child: Text("SignUp", style: TextStyle(color: Colors.white)),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.only(left: 24, right: 24),
          children: <Widget>[
            logo,
            username,
            pad,
            password,
            loginButton,
            signupButton,
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

  signUp(String username, String eMail, String password) {
    var body = jsonEncode({
      "userName": username,
      "password": password,
      "eMail": eMail,
    });

    try {
      http.post("https://tapoutapi.azurewebsites.net/api/user",
          body: body, headers: {"content-type": "application/json"});
      print("Creating user");
      setState(() {
        error = "Welcome $username !";
      });
    } catch (e) {
      print("error");
    }
  }
}
