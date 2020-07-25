import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoteInheritedWidget extends InheritedWidget{

  /*final notes=[
    {
      'title': '',
      'text': ''
    },

  ];
*/
  NoteInheritedWidget(Widget child):super(child: child);


  static NoteInheritedWidget of(BuildContext context){
    return (context.inheritFromWidgetOfExactType(NoteInheritedWidget)as NoteInheritedWidget);
  }
  @override
  bool updateShouldNotify(NoteInheritedWidget oldWidget){
    //return oldWidget.notes !=notes;
  }



}