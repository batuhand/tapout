import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tapout/details.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';
  final String username;
  HomePage({Key key, @required this.username}) : super(key: key);




  Future<List<Tasks>> _fetchTasks(String add) async{
    final String uri = "https://tapoutapi.azurewebsites.net/api/tasks/" + add;
    print(uri);
    var response = await http.get(uri);
    if(response.statusCode == 200){
      final tasks = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Tasks> listOfTasks = tasks.map<Tasks>((json){
        return Tasks.fromJson(json);
      }).toList();

      return listOfTasks;
    }else{
      throw Exception("Failed to load internet");
    }
  }  

@override
  Widget build(BuildContext context) {
    print(username);
        return Scaffold(
      appBar: AppBar(
        title: Text("tapout"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: FutureBuilder<List<Tasks>>(
        future: _fetchTasks(username),
        builder: (context, snapshot){
          if(!snapshot.hasData) return Center(child: CircularProgressIndicator());

          return ListView(
            children: snapshot.data.map((item) => ListTile(
              title: Text(item.taskName),
              subtitle: Text(item.taskDesc),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailScreen(todo: item),
                        ),
                      );
                    },
            )).toList(),
          );
        },
      ),
    );
 
  }
}

class Tasks{
  int id;
  String taskName;
  String taskDesc;
  bool isCompleted;
  String taskUser;

  Tasks({
    this.id,
    this.taskName,
    this.taskDesc,
    this.isCompleted,
    this.taskUser,
  });

  factory Tasks.fromJson(Map<String, dynamic> json){
    return Tasks(
      id: json["id"],
      taskName: json["taskName"],
      taskDesc: json["taskDesc"],
      isCompleted: json["isCompleted"],
      taskUser: json["taskUser"],
    );
  }
}