import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tapout/login.dart';

class ProfilePage extends StatelessWidget {
  final String username;

  ProfilePage({Key key, @required this.username}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tapout"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      body: FutureBuilder<User>(
          future: getUser(username),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));
            return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          snapshot.data.username,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          snapshot.data.eMail,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ListTile(
                        title: Text(
                          snapshot.data.password,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      RaisedButton(
                        color: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text("Logout",style: TextStyle(color: Colors.white),),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => new Login()));
                        },
                      )
                    ],
                  ),
                ));
          }),
      backgroundColor: Colors.red,
    );
  }
}

Future<User> getUser(String username) async {
  var result;
  final String uri = "https://tapoutapi.azurewebsites.net/api/user/" + username;
  print(uri);
  var response = await http.get(uri);
  if (response.statusCode == 200) {
    result = json.decode(response.body);
  }

  User user = User(
      id: result[0]["id"],
      username: result[0]["userName"].toString(),
      eMail: result[0]["eMail"].toString(),
      password: result[0]["password"].toString());

  print("User created");
  return user;
}

class User {
  int id;
  String username;
  String password;
  String eMail;

  User({
    this.id,
    this.username,
    this.password,
    this.eMail,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      username: json["userName"],
      password: json["password"],
      eMail: json["eMail"],
    );
  }
}
