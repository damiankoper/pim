// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:preferences/preferences.dart';

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: PreferencePage([
        PreferenceTitle(
          'General',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        DropdownPreference(
          'Cards',
          'cards',
          defaultVal: '12',
          values: ['12', '16', '20'],
        ),
        SwitchPreference(
          "Calm down, more to come...",
          "xd",
        ),
      ]),
    );
  }
}
