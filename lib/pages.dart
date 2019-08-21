


import 'package:flutter/material.dart';
import 'package:tapout/home_page.dart';
import 'package:tapout/profile_page.dart';

class Pages extends StatefulWidget{
  final String username;
  Pages({Key key, @required this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState(){
    return PagesState();
  }
}

class PagesState extends State<Pages>{


     
  int _selectedPage = 0;
 


  @override
  Widget build(BuildContext context){

     final _pageOptions = [
    HomePage(username: widget.username),
    ProfilePage(),
    ProfilePage(),
  ];
 

    print(widget.username);
    return MaterialApp(
      title: "tapout",
      home: Scaffold(
        body: _pageOptions[_selectedPage],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedPage,
          onTap: (int index){
            setState(() {
             _selectedPage = index; 
            });

          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.room_service),
              title: Text("Your Tasks")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.offline_pin),
              title: Text("Finished Tasks")
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile")
            ),
          ],
        ),
        ),
    );
  }
}