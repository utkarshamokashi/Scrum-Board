import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mainpage/Classroom_Page.dart';
import 'change_mode.dart';
import 'constants.dart';
import 'main_page.dart';
import 'global_variables.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Main extends StatelessWidget {
  Future<Widget> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var email = prefs.getString('email');
    print(email);
    runApp(MaterialApp(home: email == null ? LoginPage() : ProjectsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return LoginPage();
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final user = FirebaseAuth.instance.currentUser();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void getCurrentUser() async {
    final FirebaseUser User = await user;
    Variables.currentEmail = User.email;
    // Similarly we can get email as well
    //final uemail = user.email;
    print(Variables.currentEmail);
    //print(uemail);
  }

  Future<void> resetPassword(_email) async {
    //await _auth.sendPasswordResetEmail(email: _email);

    await _auth.sendPasswordResetEmail(email: _email).then((result) {
      final snackBar = SnackBar(
        content: Text('Password reset link has been sent!'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Navigator.of(context).pop();
      _email = "";
    }).catchError((error) {
      final snackBar = SnackBar(
        content: Text('User does not exist!'),
      );
      _scaffoldKey.currentState.showSnackBar(snackBar);
      Navigator.of(context).pop();
      _email = "";
    });
  }

  final resetEmail = TextEditingController();

  Future<String> forgotPassword(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Forgot Password",
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            content: TextField(
              style:
                  TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
              controller: resetEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: "Email",
              ),
            ),
            actions: <Widget>[
              MaterialButton(
                elevation: 5.0,
                child: Text("Send reset link"),
                onPressed: () {
                  resetPassword(resetEmail.text);

                  /*final snackBar = SnackBar(
                    content: Text('Password reset link successfully sent'),
                  );
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  resetEmail.text="";
                  Navigator.of(context).pop();*/
                },
              )
            ],
          );
        });
  }

  final _auth = FirebaseAuth.instance;

  String _email;

  String _password;

  bool _passwordVisible = false;

  Future<String> noConnection(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Not Connected to Internet",
              style:
              TextStyle(color: Theme.of(context).textTheme.bodyText2.color),
            ),
            actions: <Widget>[
              MaterialButton(
                child: Text(
                  'OK',
                ),
                onPressed: ()=>Navigator.pop(context),
              )
            ],
          );
        });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //type: MaterialType.transparency,
      theme: Theme.of(context),
      home: Container(
        child: Stack(
          children: <Widget>[
            Container(
              child: Scaffold(
                key: _scaffoldKey,
                //backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 250),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText2.color,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: TextField(
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                            onChanged: (value) {
                              _email = value;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.start,
                            decoration:
                                kInputDecoration.copyWith(hintText: "Email")),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: TextField(
                            keyboardType: TextInputType.text,
                            //controller: _userPasswordController,
                            onChanged: (value) {
                              _password = value;
                            },
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText2.color,
                            ),
                            obscureText: !_passwordVisible,
                            decoration: kInputDecoration.copyWith(
                              hintText:
                                  "Password", //This will obscure text dynamically
                              // Here is key idea
                              suffixIcon: IconButton(
                                  icon: Icon(
                                    // Based on passwordVisible state choose the icon
                                    _passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .color,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  }
                                  // Update the state i.e. toogle the state of passwordVisible variable

                                  ),
                            ),
                          )
                          /*Row(
                          children: <Widget>[
                            TextField(
                                style:TextStyle(
                                  color: Theme.of(context).textTheme.bodyText2.color,
                                ),
                                onChanged: (value) {
                                  _password = value;
                                },
                                keyboardType: TextInputType.visiblePassword,
                                textAlign: TextAlign.start,
                                obscureText: true,
                                decoration: kInputDecoration.copyWith(
                                    hintText: "Password")),
    IconButton(
    icon: Icon(
    // Based on passwordVisible state choose the icon
    passwordVisible
    ? Icons.visibility
        : Icons.visibility_off,
    color: Theme.of(context).primaryColorDark,
    ),
    onPressed: () {
    // Update the state i.e. toogle the state of passwordVisible variable
    setState(() {
    _passwordVisible = !_passwordVisible;
    });})
                          ],
                        ),*/
                          ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              forgotPassword(context);
                            },
                            focusColor: Colors.transparent,
                            child: Text("Forgot Password?",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      Theme.of(context).accentIconTheme.color,
                                ),
                                textAlign: TextAlign.end),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Center(
                        child: MaterialButton(
                          color: Theme.of(context).accentIconTheme.color,
                          // ignore: missing_return
                          onPressed: () async {
                            //TODO: 2. Creating SignIn method
                            try {
                              final result =
                                  await InternetAddress.lookup('google.com');
                              if (result.isNotEmpty &&
                                  result[0].rawAddress.isNotEmpty) {
                                try {
                                  final user =
                                      await _auth.signInWithEmailAndPassword(
                                          email: _email, password: _password);
                                  if (user != null) {
                                    var userRecord = FirebaseAuth.instance
                                        .currentUser()
                                        .then((user) => Variables.currentEmail =
                                            user.email);
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setString('email', _email);

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext ctx) =>
                                                ProjectsPage()));
                                    print("Logged IN");
                                    print(Variables.currentEmail);

                                    /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProjectsPage(),
                                      ));*/
                                  }
                                } catch (e) {
                                  print(e);
                                  setState(() {
                                    final snackBar = SnackBar(
                                      content: Text('Wrong Email or Password'),
                                    );
                                    _scaffoldKey.currentState
                                        .showSnackBar(snackBar);
                                  });
                                }
                              }
                            } on SocketException catch (_) {
                              print("no connection");
                              return noConnection(context);

                            }
                          },
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.headline6,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      /*MaterialButton(
                        color: Theme.of(context).accentIconTheme.color,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectsPage(),
                            )),
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
            image(),
            Container(
              color: Colors.transparent,
              height: 250,
              child: Padding(
                padding: const EdgeInsets.only(left: 30, top: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Scrum     ',
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).iconTheme.color,
                        decoration: TextDecoration.none,
                      ),
                    ),
                    Text(
                      '    Board',
                      style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).iconTheme.color,
                        decoration: TextDecoration.none,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: missing_return
Widget image() {
  if (ThemesNotifier.modeImage == "light") {
    return Container(
        height: 260,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Images/Scrum_light.png'), fit: BoxFit.cover),
        ));
  } else if (ThemesNotifier.modeImage == "dark") {
    return Container(
        height: 250,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('Images/Scrum_dark .png'), fit: BoxFit.cover),
        ));
  }
}
