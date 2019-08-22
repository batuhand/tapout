import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tapout/details.dart';

class HomePage extends StatelessWidget {
  static String tag = 'home-page';
  final String username;
  final newTaskNameController = new TextEditingController();
  final newTaskDescController = new TextEditingController();
  HomePage({Key key, @required this.username}) : super(key: key);

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
      for (int i = 0; i < listOfTasks.length; i++) {
        if (listOfTasks[i].isCompleted == false) {
          unfinished.add(listOfTasks[i]);
        }
      }
      print(listOfTasks[0].id);

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
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white)));

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
                                            child: Text("Finish Task",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white)),
                                            onPressed: () {
                                              finishTask(item.id, item.taskName,
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
      floatingActionButton: FloatingActionButton(
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
                                controller: newTaskNameController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.red,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Task Name",
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
                                controller: newTaskDescController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.red,
                                autofocus: false,
                                decoration: InputDecoration(
                                  hintText: "Task Description",
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
                            child: Text("Create new Task",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            onPressed: () {
                              if (newTaskNameController.text != null &&
                                  newTaskDescController.text != null) {
                                createTask(
                                    username,
                                    newTaskNameController.text.toString(),
                                    newTaskDescController.text.toString());
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
        child: Icon(
          Icons.loupe,
          color: Colors.red,
        ),
        backgroundColor: Colors.white,
      ),
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
      print("Creating");
      print(result);
    });
  } catch (e) {
    print("error");
  }
}

finishTask(int id, String taskName, String taskDesc, String taskUser) {
  var body = jsonEncode({
    "id": id,
    "taskName": taskName,
    "taskDesc": taskDesc,
    "isCompleted": true,
    "taskUser": taskUser,
  });

  var uri = "https://tapoutapi.azurewebsites.net/api/tasks/" + id.toString();

  try {
    http.put(uri,
        body: body,
        headers: {"content-type": "application/json"}).then((response) {
      print("Finishing Task");
    });
  } catch (e) {
    print("error");
  }
}


rewokeTask(int id, String taskName, String taskDesc, String taskUser) {
  var body = jsonEncode({
    "id": id,
    "taskName": taskName,
    "taskDesc": taskDesc,
    "isCompleted": false,
    "taskUser": taskUser,
  });

  var uri = "https://tapoutapi.azurewebsites.net/api/tasks/" + id.toString();

  try {
    http.put(uri,
        body: body,
        headers: {"content-type": "application/json"}).then((response) {
      print("Finishing Task");
    });
  } catch (e) {
    print("error");
  }
}

deleteTask(int id) {
  var uri = "https://tapoutapi.azurewebsites.net/api/tasks/" + id.toString();
  try {
    http.delete(uri);
    print("Deleting");
  } catch (e) {
    print("error");
  }
}

class Tasks {
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

  factory Tasks.fromJson(Map<String, dynamic> json) {
    return Tasks(
      id: json["id"],
      taskName: json["taskName"],
      taskDesc: json["taskDesc"],
      isCompleted: json["isCompleted"],
      taskUser: json["taskUser"],
    );
  }
}
