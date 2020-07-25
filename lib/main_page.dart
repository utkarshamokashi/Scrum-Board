import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mainpage/global_variables.dart';
import 'package:mainpage/login_page.dart';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'Classroom_Page.dart';
import 'Notes_main.dart';
import 'Settings.dart';

class MainPage extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }
  bool myInterceptor(bool stopDefaultButttonEvent,)
  {
    if(stopDefaultButttonEvent == false) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProjectsPage()),
      );
      print(stopDefaultButttonEvent);
      return true;
    }
  }
  String displayText;
  Widget navList({IconData icon, String text, GestureTapCallback onTap}) {
    return ListTile(
      contentPadding: EdgeInsets.all(20.0),
      leading: Icon(icon, color: Theme.of(context).iconTheme.color, size: 34.0),
      title: Text(
        text,
        style: Theme.of(context).appBarTheme.textTheme.headline6,
      ),
      onTap: onTap,
    );
  }

  Widget boxes(displayText) {
    return FlatButton(
      padding: EdgeInsets.all(10.0),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Notes()),
        );
        Variables.notesPage = displayText;
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).buttonColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 6,
              offset: Offset(2, 3), // changes position of shadow
            ),
          ],
        ),
        height: 190,
        width: 170,
        child: Center(
          child: Text(
            displayText,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  var G;
  var y = randomAlphaNumeric(8);
  var a=Variables.currentProjectCode;
  Future<String> showProjectCode(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Project Code",
              style:
              TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            content: Text(
              Variables.currentProjectCode,
              style:
              TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.autorenew,
                    color: Theme.of(context).textTheme.bodyText2.color,
                  ),
                  onPressed: () async {
                    await _collab
                        .collection("project")
                        .where("project_id",
                        isEqualTo: Variables.currentProjectId)
                        .snapshots()
                        .listen((data) => data.documents.forEach((doc) {
                      setState(() {
                        G = doc["project_id"];
                        print(G);
                        _collab
                            .collection("project")
                            .document(G)
                            .updateData({
                          "project_code": y,
                        });
                        Variables.currentProjectCode = y;
                      });
                    }));
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      content: Text('Project code has been changed'),
                    );
                    _scaffoldKey.currentState.showSnackBar(snackBar);
                    /*Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectsPage()),
                  );*/
                  }),
              IconButton(
                icon: Icon(
                  Icons.content_copy,
                  color: Theme.of(context).textTheme.bodyText2.color,
                ),
                onPressed: () => Clipboard.setData(
                    new ClipboardData(text: "Join my project with this code:$a")),
              )
            ],
          );
        });
  }

  Widget collaborators() {
    return PopupMenuButton(
      itemBuilder: (context) {
        var list = List<PopupMenuEntry<Object>>();
        list.add(
          PopupMenuItem(
            value: 1,
            child: Text(
              "Created By -",
              style: Theme.of(context)
                  .textTheme
                  .bodyText2
                  .copyWith(fontSize: 20, color: Colors.blue.shade700),
            ),
          ),
        );
        list.add(
          PopupMenuItem(
            value: 2,
            child: Text(
              Variables.projectCreatedBy,
              style:
              Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
            ),
          ),
        );
        if (Variables.projectCollaborator != null) {
          list.add(
            PopupMenuItem(
              value: 3,
              child: Text(
                "Collaborators -",
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(fontSize: 20, color: Colors.blue.shade700),
              ),
            ),
          );
          for (var i = 0; i < Variables.projectCollaborator.length; i++) {
            list.add(
              PopupMenuItem(
                value: 4 + i,
                child: FlatButton(
                    padding: const EdgeInsets.all(0),
                    child: Text(Variables.projectCollaborator[i],
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(fontSize: 18)),
                    onPressed: () {
                      if (Variables.currentEmail ==
                          Variables.projectCreatedBy) {
                        removeCollaborator(
                            context, Variables.projectCollaborator[i]);
                        Navigator.of(context).pop();
                      } else {
                        final snackBar = SnackBar(
                          content: Text('You cannot Remove Collaborators'),
                        );
                        _scaffoldKey.currentState.showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      }
                      //Navigator.of(context).pop();
                    }),
              ),
            );
          }
        }
        return list;
      },
      icon: Icon(Icons.assignment_ind),
      offset: Offset(0, 100),
    );
  }

  final _collab = Firestore.instance;
  var C;
  Future<String> removeCollaborator(
      BuildContext context, var collaboratorName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Remove this Collaborator?",
              style:
              TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            content: Text(
              collaboratorName,
              style:
              TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Remove"),
                onPressed: () async {

                  await _collab
                      .collection("project")
                      .where("project_id",
                      isEqualTo: Variables.currentProjectId)
                      .snapshots()
                      .listen((data) => data.documents.forEach((doc) {
                    setState(() {
                      C = doc["project_id"];
                      print(C);
                      _collab
                          .collection("project")
                          .document(C)
                          .updateData({
                        "collaborators":
                        FieldValue.arrayRemove([collaboratorName])
                      });
                    });
                  }));
                  //Get.to(ProjectsPage());
                  /* Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectsPage()),
                  );*/
                  Navigator.of(context).pop();
                  final snackBar = SnackBar(
                    content: Text('Collaborator Removed'),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                },
              )
            ],
          );
        });
  }

/*Widget collaborators(){

    return PopupMenuButton<int>(
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          child: Text(
            "Created By -",
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 20),
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Text(
            Variables.projectCreatedBy,
            style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Text(
            "Collaborators",
            style: TextStyle(
              color:Colors.blue.shade700,
              fontSize: 20,
            ),
          ),
        ),
        PopupMenuItem(
          value: 4,
          child:,
          */ /*for(int i=0;i<Variables.projectCollaborators.length;i++){
  return Text(
  Variables.projectCollaborator[i],
  style: Theme.of(context).textTheme.bodyText2.copyWith(fontSize: 18),
  ),
  }*/ /*
        ),
      ],
      icon: Icon(Icons.assignment_ind),
      offset: Offset(0, 100),
    );
}*/
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Variables.currentProject = "";
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProjectsPage()),
              );
            },
          ),
          centerTitle: true,
          title: Text(
            Variables.currentProject,
            style: Theme.of(context).appBarTheme.textTheme.headline6,
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                if (Variables.projectCreatedBy == Variables.currentEmail) {
                  showProjectCode(context);
                } else {
                  final snackBar = SnackBar(
                    content: Text('You cannot view the Project Code'),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                }
              },
            ),
            collaborators(),
            /*IconButton(icon: Icon(Icons.assignment),
                onPressed:()=> print(Variables.projectCollaborator))*/
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: GridView.count(
              //primary: false,
              crossAxisCount: 2,
              children: <Widget>[
                boxes('Features'),
                boxes('Ice Box'),
                boxes('Emergency'),
                boxes('In Progress'),
                boxes('Testing'),
                boxes('Complete'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
