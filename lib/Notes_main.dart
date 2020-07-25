import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'grid.dart';
import 'note_inherited_widget.dart';
//Grid grid=new Grid();
/*void main() {
  runApp(Notes());


}*/

class Notes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return NoteInheritedWidget(
      MaterialApp(
        title: 'Title',
        debugShowCheckedModeBanner: false,
        theme: Theme.of(context),
        home: Grid(),
      ),
    );
  }
}
