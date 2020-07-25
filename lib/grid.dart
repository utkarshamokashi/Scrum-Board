import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:focused_menu/modals.dart';
import 'package:mainpage/global_variables.dart';
import 'main_page.dart';
import 'main_page.dart';
import 'screentwo.dart';
import 'note_inherited_widget.dart';
import 'package:focused_menu/focused_menu.dart';

//int i=0;

class Grid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Gridviewlist2();
  }
}

class DynamicWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new TextField(
        decoration: new InputDecoration(hintText: 'Enter data'),
      ),
    );
  }
}

List<DynamicWidget> listDynamic = [];

addDynamic() {
  listDynamic.add(DynamicWidget());
}

class Gridviewlist2 extends State<Grid> {

  //List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;
  final _postIt = Firestore.instance;

  Widget PostIt(String title, String content, String notesId) {
    return FocusedMenuHolder(
      blurSize: 10,
      menuWidth: MediaQuery.of(context).size.width * 0.5,
      menuItemExtent: 50,
      duration: Duration(milliseconds: 300),
      menuItems: <FocusedMenuItem>[
        FocusedMenuItem(
            title: Text(
              'Transfer to',
              style: Theme.of(context).appBarTheme.textTheme.headline6,
            ),
            backgroundColor: Theme.of(context).appBarTheme.color,
            trailingIcon: Icon(
              Icons.import_export,
              color: Theme.of(context).appBarTheme.textTheme.headline6.color,
            )),
        FocusedMenuItem(
            title: Text('Features',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                )),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () async {
              await _postIt.collection("notes").document(notesId).updateData({
                "category": "Features",
              });
            }),
        FocusedMenuItem(
            title: Text('Ice Box',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                )),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () async {
              await _postIt.collection("notes").document(notesId).updateData({
                "category": "Ice Box",
              });
            }),
        FocusedMenuItem(
            title: Text('Emergency',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                )),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () async {
              await _postIt.collection("notes").document(notesId).updateData({
                "category": "Emergency",
              });
            }),
        FocusedMenuItem(
            title: Text('In Progress',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                )),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () async {
              await _postIt.collection("notes").document(notesId).updateData({
                "category": "In Progress",
              });
            }),
        FocusedMenuItem(
            title: Text('Testing',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                )),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () async {
              await _postIt.collection("notes").document(notesId).updateData({
                "category": "Testing",
              });
            }),
        FocusedMenuItem(
            title: Text('Complete',
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText2.color,
                )),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onPressed: () async {
              await _postIt.collection("notes").document(notesId).updateData({
                "category": "Complete",
              });
            }),
        FocusedMenuItem(
            title: Text('Delete',
                style: TextStyle(
                  color: Colors.red,
                )),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            trailingIcon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
            onPressed: () async {
              await _postIt.collection("notes").document(notesId).delete();
            }),
      ],
      onPressed: () {
        Variables.currentNote = notesId;
        print(Variables.currentNote);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Notes(Notemode.Editing, notesId),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _NoteTitle(title),
                  SizedBox(
                    height: 10,
                  ),
                  _NoteText(content),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    /*setState(() {
         print(_notes);
       });*/
  }
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
        MaterialPageRoute(builder: (context) => MainPage()),
      );
      print(stopDefaultButttonEvent);
      return true;
    }
  }
  @override

  //String s,result;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              //color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              Variables.notesPage = "";
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MainPage(),
                ),
              );
            }),
        centerTitle: true,
        title: Text(Variables.notesPage),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: StreamBuilder(
            stream: _postIt
                .collection("notes")
                .where("project_id", isEqualTo: Variables.currentProjectId)
                .where("category", isEqualTo: Variables.notesPage)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Text(
                  'No Data...',
                );
              } else {
                var postIts = snapshot.data.documents;
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: postIts.length,
                  itemBuilder: (context, index) {
                    return PostIt(
                      postIts[index]["notes_title"],
                      postIts[index]["project_notes"],
                      postIts[index]["notes_id"],
                    );
                  },
                );
              }
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Notes(Notemode.Adding, null)),
          );
          /*setState(
                () {
              print(_notes);
            },
          );*/
        },
        backgroundColor: Colors.black,
        tooltip: 'Add Note',
        child: new Icon(Icons.add, color: Theme.of(context).iconTheme.color),
      ),
    );
  }
}

class _NoteTitle extends StatelessWidget {
  final String _title;

  _NoteTitle(this._title);

  @override
  Widget build(BuildContext context) {
    return Text(
      _title,
      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 24),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _NoteText extends StatelessWidget {
  final String _text;

  _NoteText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16),
      maxLines: 7,
      overflow: TextOverflow.ellipsis,
    );
  }
}

