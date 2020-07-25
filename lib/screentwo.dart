import 'dart:math';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:mainpage/Classroom_Page.dart';
import 'package:random_string/random_string.dart';
import 'dart:math' show Random;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'global_variables.dart';
import 'main_page.dart';
import 'note_inherited_widget.dart';
import 'grid.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';

enum Notemode { Editing, Adding }

//void main() {
//runApp(MaterialApp(home: MyApp()));
//}
class User {
  final String text, content;
  const User({
    this.text,
    this.content,
  });
}

class Notes extends StatefulWidget {
  final Notemode notemode;
  final String notesId;

  Notes(this.notemode, this.notesId);
  //Variables.currentNotes=notesId;
//ToDo : create a variable for passing current note Id
  @override
  NotesState createState() => NotesState();
}

class NotesState extends State<Notes> {
  @override
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  //List<Map<String, String>> get _notes => NoteInheritedWidget.of(context).notes;

  void didChangeDependencies() {
    _note.collection("notes")
        .where("notes_id", isEqualTo: Variables.currentNote).snapshots().listen((data)=>data.documents.forEach((doc) {
      setState(() {
         Variables.currentNoteTitle=doc["notes_title"];
         Variables.currentNoteContent=doc["project_notes"];
         if (widget.notemode == Notemode.Editing) {
           _titleController.text = Variables.currentNoteTitle;
           _contentController.text =Variables.currentNoteContent;
         }
      });
    }));

  }
  final _note = Firestore.instance;
  var b=randomNumeric(6);
  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
        }
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
void backButton() async{
 String title = _titleController.text;
  String text = _contentController.text;
    if (widget?.notemode == Notemode.Adding) {
      if(title!="" || text!="") {
        await _note.collection("notes").document(b).setData({
          "notes_title": title,
          "project_notes": text,
          "project_id": Variables.currentProjectId,
          "updated_at": DateTime.now(),
          "updated_by": Variables.currentEmail,
          "category": Variables.notesPage,
          "created_by": Variables.currentEmail,
          "created_at": DateTime.now(),
          "notes_id": b,
          //"notes_id": FieldPath.documentId,
        });
              }
      //_notes.add({'title': title, 'text': text});
    } else if (widget?.notemode == Notemode.Editing) {
      await _note.collection("notes").document(Variables.currentNote).updateData({
        "notes_title": title,
        "project_notes": text,
        "project_id": Variables.currentProjectId,
        "updated_at": DateTime.now(),
        "updated_by": Variables.currentEmail,
        "category": Variables.notesPage,
      });
            //print(Variables.currentNote);
      //_notes[widget.index] = {'title': title, 'text': text};
    }
 Navigator.push(
   context,
   MaterialPageRoute(builder: (context) => Grid()),
 );
}
  bool myInterceptor(bool stopDefaultButttonEvent,)
  {
    if(stopDefaultButttonEvent == false) {
      backButton();
      print(stopDefaultButttonEvent);
      return true;
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: Theme.of(context),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              backButton();
              /*Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Grid()),
              );*/
            },
          ),
          centerTitle: true,
          title: Text(widget.notemode == Notemode.Adding
              ? 'Add screen'
              : 'Edit screen'),
        ),
        body: SafeArea(
          child: Stack(
            fit: StackFit.passthrough,
            children: <Widget>[
              Container(
                height: 800,
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                padding: EdgeInsets.fromLTRB(25, 64, 25, 25),
                child: new TextFormField(
                  expands: true,
                  maxLines: null,
                  controller: _contentController,
                  cursorColor: Colors.black,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: 'Content'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color,
                    fontSize: 20,
                  ),
                ),
              ),
              Container(
                height: 49.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 6,
                      offset: Offset(2, 3), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 4, horizontal: 25),
                child: new TextFormField(
                  cursorColor: Colors.black,
                  controller: _titleController,
                  decoration: new InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: 'Title'),
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText2.color,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
