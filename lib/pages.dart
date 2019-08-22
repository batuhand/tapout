import 'package:flutter/material.dart';
import 'package:tapout/finished_tasks.dart';
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
    Finished(username: widget.username),
    ProfilePage(username: widget.username),
  ];
 
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
              icon: Icon(Icons.room_service,color: Colors.red,),
              title: Text("Your Tasks",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54))
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.offline_pin,color: Colors.red,),
              title: Text("Finished Tasks",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54))
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person,color: Colors.red,),
              title: Text("Profile",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black54))
            ),
          ],
        ),
        ),
    );
  }
}