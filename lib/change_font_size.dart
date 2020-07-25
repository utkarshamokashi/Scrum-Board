import 'package:flutter/material.dart';
import 'package:mainpage/Settings.dart';
import 'package:provider/provider.dart';
import 'global_variables.dart';

import 'change_mode.dart';

class FontSizeModify extends StatefulWidget {
  @override
  _FontSizeModifyState createState() => _FontSizeModifyState();
}

class _FontSizeModifyState extends State<FontSizeModify> {
  @override
  Widget build(BuildContext context) {
    Variables a;
    double dropdownValue = 24;
    return MaterialApp(
      theme: Theme.of(context),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
              ),
              onPressed: () =>Navigator.push(
                  context,MaterialPageRoute(builder:(context)=>SettingsPane())
              )
          ),
          centerTitle: true,
          title: Text(
            'Settings',
          ),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              MaterialButton(
                color:Colors.blue,
                child:Text('abc',
                style: Theme.of(context).textTheme.bodyText2,
                ),
                onPressed: ()=>print(Variables.fontSize),
              ),
              DropdownButton<double>(
                value: dropdownValue,
                icon: Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (double newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    ThemesNotifier themesNotifier =
                        Provider.of<ThemesNotifier>(context, listen: false);
                    themesNotifier.changeFontSize(size: newValue);
                    print(Variables.fontSize);
                  });
                },
                items: <double>[24, 25, 26, 27]
                    .map<DropdownMenuItem<double>>((double value) {
                  return DropdownMenuItem<double>(
                    value: value,
                    child: Text('$value'),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
