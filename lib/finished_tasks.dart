import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tapout/details.dart';

import 'home_page.dart';

class Finished extends StatelessWidget {
  static String tag = 'home-page';
  final String username;
  final newTaskNameController = new TextEditingController();
  final newTaskDescController = new TextEditingController();
  Finished({Key key, @required this.username}) : super(key: key);

  Future<List<Tasks>> _fetchTasks(String add) async {
    final String uri = "https://tapoutapi.azurewebsites.net/api/tasks/" + add;
    print(uri);
    var response = await http.get(uri);
    if (response.statusCode == 200) {
      final tasks = json.decode(response.body).cast<Map<String, dynamic>>();
      List<Tasks> listOfTasks = tasks.map<Tasks>((json) {
        return Tasks.fromJson(json);
      }).toList();

      List<Tasks> unfinished = [];
      for(int i=0; i<listOfTasks.length; i++){
        if(listOfTasks[i].isCompleted == true){
          unfinished.add(listOfTasks[i]);
        }
      }

      return unfinished;
    } else {
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
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)));

          return ListView(
            children: snapshot.data
                .map((item) => Card(
                      borderOnForeground: true,
                      child: ListTile(
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
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Form(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Text(item.taskName),
                                        Text(item.taskDesc),
                                        RaisedButton(
                                            color: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Text("Rewoke Task",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            onPressed: () {
                                              rewokeTask(item.id, item.taskName,
                                                  item.taskDesc, item.taskUser);
                                              Navigator.pop(context);
                                            }),
                                        RaisedButton(
                                            color: Colors.redAccent,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                            ),
                                            child: Text("Delete Task",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            onPressed: () {
                                              deleteTask(item.id);
                                              Navigator.pop(context);
                                            })
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ))
                .toList(),
          );
        },
      ),
      backgroundColor: Colors.red[500],
    );
  }
}

createTask(String username, String taskName, String taskDesc) {
  var body = jsonEncode({
    "taskName": taskName,
    "taskDesc": taskDesc,
  });

  var uri = "https://tapoutapi.azurewebsites.net/api/user/" + username;
  try {
    http.put(uri,
        body: body,
        headers: {"content-type": "application/json"}).then((response) {
      var result = json.decode(response.body);
      //print(result["token"]);
      print("Creating");
      print(result);
    });
  } catch (e) {
    print("error");
  }
}



// class Tasks {
//   int id;
//   String taskName;
//   String taskDesc;
//   bool isCompleted;
//   String taskUser;

//   Tasks({
//     this.id,
//     this.taskName,
//     this.taskDesc,
//     this.isCompleted,
//     this.taskUser,
//   });

//   factory Tasks.fromJson(Map<String, dynamic> json) {
//     return Tasks(
//       id: json["id"],
//       taskName: json["taskName"],
//       taskDesc: json["taskDesc"],
//       isCompleted: json["isCompleted"],
//       taskUser: json["taskUser"],
//     );
//   }
// }
