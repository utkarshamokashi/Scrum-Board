import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final _firestore = Firestore.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Theme.of(context),
     home: Scaffold(
      appBar: AppBar(
        title:Text('My Profile',
        style: Theme.of(context).appBarTheme.textTheme.headline6,
        ),
      ),
       body:Column(
         children: <Widget>[
           Text('Name'),
           FlatButton(
             child: Text('Email-->'),
             onPressed: ()async{
               await _firestore.collection('email').snapshots().listen((data) {});
             },
           ),


         ],
       ),
     ),
    );
  }
}
