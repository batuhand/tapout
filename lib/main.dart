import 'package:flutter/material.dart';
import 'package:tapout/home_page.dart';
import 'package:tapout/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    Login.tag: (context) => Login(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tapout',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: 'Nunito',
      ),
      home: Login(),
      routes: routes,
    );
  }
}

