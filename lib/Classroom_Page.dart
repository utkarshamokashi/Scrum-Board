import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Settings.dart';
import 'global_variables.dart';
import 'login_page.dart';
import 'main_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;

class ProjectsPage extends StatefulWidget {
  @override
  _ProjectsPageState createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
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
      SystemNavigator.pop();
      print(stopDefaultButttonEvent);
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: Theme.of(context), home: Home());
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int i = 0;
  String S;
  var lists = [];
  //var lists=List<String>.filled(.infinity, "a", growable:true);
  //List<String> lists = List<String>(100);
  final _project = Firestore.instance;
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

  final myController = TextEditingController();
  Future<String> joinExistingProject(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Join Project",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            content: TextField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
              controller: myController,
              decoration: InputDecoration(
                hintText: "Project code",
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Join"),
                onPressed: () async{
                  await _project
                  .collection("project")
                  .where("project_code", isEqualTo: myController.text).snapshots().listen((data)=>data.documents.forEach((doc) {
                    setState(() {
                    S=doc["project_id"];
                    print(S);
                    _project.collection("project").document(S).updateData({"collaborators": FieldValue.arrayUnion([Variables.currentEmail])});
                    });
                  }));
          Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
var f=randomNumeric(8);
  Future<String> createNewProject(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Create Project",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText2.color),
                  controller: myController,
                  decoration: InputDecoration(
                    focusColor: Theme.of(context).buttonColor,
                    hintText: "Project Name",
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Create"),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await _project.collection("project").document(f).setData({
                    "project_name": myController.text,
                    "project_id": f,
                    "project_code": randomAlphaNumeric(8),
                    "created_at": DateTime.now(),
                    "created_by": Variables.currentEmail,
                  });
                },
              )
            ],
          );
        });
  }

  List<Widget> projectList = [];
  Widget offsetPopup() => PopupMenuButton<int>(
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 1,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                createNewProject(context).then((onValue) {});
              },
              child: Text(
                "Create Project",
              ),
            ),
          ),
          PopupMenuItem(
            value: 2,
            child: FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                joinExistingProject(context).then((onValue) {});
              },
              child: Text(
                "Join Project",
              ),
            ),
          ),
        ],
        icon: Icon(Icons.add),
        offset: Offset(0, 100),
      );
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Widget card(String text,String projectCode,String createdBy, List<dynamic> collaborators, String projectId) {
    myController.text = "";
    return Card(
      child: Container(
        decoration:BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8.0))
        ),
        child: FocusedMenuHolder(
          blurSize: 10,
          menuWidth: MediaQuery.of(context).size.width * 0.5,
          menuItemExtent: 50,
          duration: Duration(milliseconds: 300),
          menuItems: <FocusedMenuItem>[
            FocusedMenuItem(
                title: Text(
                  'Delete',
                  style: Theme.of(context).appBarTheme.textTheme.headline6.copyWith(color:Colors.red),
                ),
                trailingIcon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
          onPressed: () async { if(Variables.currentEmail==createdBy) {
            await _project.collection("project").document(projectId).delete();
          }
          else{
            final snackBar = SnackBar(
              content: Text('You cannot delete this Project'),
            );
            _scaffoldKey.currentState.showSnackBar(snackBar);
          }
    })
          ],
          //color: Theme.of(context).buttonColor,
          onPressed: () {
            Variables.currentProject=text;
            Variables.currentProjectId=projectId;
            Variables.currentProjectCode=projectCode;
            Variables.projectCreatedBy=createdBy;
            Variables.projectCollaborator=collaborators;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MainPage(),
              ),
            );
          },
          child: Container(
            decoration:BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Theme.of(context).buttonColor,
            ),
            height: 100,
            width: double.infinity,
            child: Center(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(fontWeight: FontWeight.w700, fontSize: 40),
              ),
            ),
          ),
        ),
      ),
    );
  }
  var a;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Scrum Board'),
        actions: <Widget>[
          offsetPopup(),
        ],
      ),
      drawer: Drawer(
        child: Container(
          padding: EdgeInsets.zero,
          color: Theme.of(context).primaryColor,
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                padding: EdgeInsets.fromLTRB(15.0, 45.0, 0.0, 0.0),
                child: Text(
                  'SCRUM BOARD',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              navList(
                icon: Icons.settings,
                text: 'SETTINGS',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsPane()),
                ),
              ),
              navList(
                icon: Icons.exit_to_app,
                text: 'LOGOUT',
                onTap: () async{
                  Variables.currentEmail="";
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('email');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (BuildContext ctx) => LoginPage()));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> LoginPage()),
                  );
                }
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ListView(
                shrinkWrap:true,
                children: <Widget>[
                 new StreamBuilder(
                   stream: _project
                       .collection("project")
                       .where("created_by", isEqualTo: Variables.currentEmail)
                       .snapshots(),
                   builder: (context, snapshot) {
                     if (!snapshot.hasData) {
                       return Text(
                         'No Data...',
                       );
                     } else {
                       var lists = snapshot.data.documents;
                       return ListView.builder(
                           shrinkWrap: true,
                           itemCount: lists.length,
                           itemBuilder: (BuildContext context, int index) {
                             return card(lists[index]["project_name"],lists[index]["project_code"],lists[index]["created_by"],lists[index]["collaborators"],lists[index]["project_id"]);
                           });
                     }
                   },
                 ),
                  new StreamBuilder(
                    stream: _project
                        .collection("project")
                        .where("collaborators",arrayContains: Variables.currentEmail)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Text(
                          'No Data...',
                        );
                      } else {
                        var lists = snapshot.data.documents;
                        return ListView.builder(
                            shrinkWrap: true,
                            itemCount: lists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return card(lists[index]["project_name"],lists[index]["project_code"],lists[index]["created_by"],lists[index]["collaborators"],lists[index]["project_id"]);
                            });
                      }
                    },
                  ),
        ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
