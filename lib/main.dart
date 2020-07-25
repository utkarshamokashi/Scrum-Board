import 'package:flutter/material.dart';
import 'package:mainpage/Classroom_Page.dart';
import 'package:mainpage/Notes_main.dart';
import 'package:mainpage/global_variables.dart';
import 'package:mainpage/login_page.dart';
import 'package:mainpage/main_page.dart';
import 'package:mainpage/Settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'change_mode.dart';
import 'change_font.dart';
import 'change_font_size.dart';
import 'package:provider/provider.dart';

/*void main() {
  return runApp(ChangeNotifierProvider(
    child: MyApp(),
    create: (BuildContext context) => ThemesNotifier(isDarkMode: false),
  ));
}*/
Future<Widget> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  print(email);
  runApp(ChangeNotifierProvider(
      child:MyApp(),

        create: (BuildContext context) => ThemesNotifier(),
  ),
  );
  if(email!=null){Variables.currentEmail=email;
  print(Variables.currentEmail);
}
}

var email;
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemesNotifier>(
      builder: (context, ThemesNotifier themeNotifier, child) {
        return MaterialApp(
          theme: themeNotifier.darkTheme?light:dark,
          home:email == null ? LoginPage() : ProjectsPage(),
          /*initialRoute: '/',
          routes: {
            '/': (context) => Main(),
            '/Projects': (context) => ProjectsPage(),
            '/mainPage': (context) => MainPage(),
            '/settings': (context) => SettingsPane(),
            '/changeFont': (context) => FontChange(),
            '/modeSwitch': (context) => ModeSwitch(),
            '/changeFontSize': (context) => FontSizeModify(),
            '/notesPage': (context) => Notes(),
          },*/
        );
      },
    );
  }
}
