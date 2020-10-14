// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:memory/game/game.dart';
import 'package:memory/options.dart';
import 'package:preferences/preferences.dart';

main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await PrefService.init(prefix: 'pref_');
  runApp(MyApp());
}

final mainButtonThemeFactory = (Widget child) => ButtonTheme(
      minWidth: 100,
      height: 100,
      child: child,
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      theme: ThemeData.dark().copyWith(primaryColor: Colors.indigo),
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
        ),
        body: Builder(
          builder: (innerContext) => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Memory',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 52),
                    ),
                    Text('simple game to get engeneering degree')
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        margin: EdgeInsets.only(right: 12),
                        child: mainButtonThemeFactory(RaisedButton(
                          onPressed: () {
                            Navigator.push(
                                innerContext,
                                MaterialPageRoute(
                                    builder: (context) => Game()));
                          },
                          child: Text('Play'),
                        ))),
                    mainButtonThemeFactory(RaisedButton(
                      onPressed: () {
                        Navigator.push(innerContext,
                            MaterialPageRoute(builder: (context) => Options()));
                      },
                      child: Text('Options'),
                    )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
