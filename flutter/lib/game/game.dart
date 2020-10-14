// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:memory/game/gameCard.dart';
import 'package:preferences/preference_service.dart';

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}

final gameTextStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);

class _GameState extends State {
  int _seconds = 0;
  int _cards = 12;
  int _counterHits = 0;
  int _counterAll = 0;
  DateTime _started;
  Timer _timer;
  List<GameCard> _gameCards = [];

  @override
  void initState() {
    super.initState();
    _started = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds = DateTime.now().difference(_started).inSeconds;
      });
    });
    setState(() {
      initCards();
    });
  }

  void initCards() {
    _cards = int.parse(PrefService.sharedPreferences.getString('pref_cards'));
    for (var i = 1; i <= _cards / 2; i++) {
      var card = GameCard(i);
      _gameCards.add(card);
    }

    List<GameCard> pairs = [];
    for (GameCard card in _gameCards) {
      var pairCard = GameCard(card.number);
      card.pair = pairCard;
      pairCard.pair = card;
      pairs.add(card);
    }
    _gameCards.addAll(pairs);
    _gameCards.shuffle();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Builder(
        builder: (innerContext) => Container(
          margin: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Time: ${getTimeString()}",
                    style: gameTextStyle,
                  ),
                  Text("Points: $_counterHits/$_counterAll",
                      style: gameTextStyle)
                ],
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: GridView.count(
                    crossAxisCount: 4,
                    children: _gameCards
                        .map((card) => Icon(Icons.mediation))
                        .toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getTimeString() {
    String h = (_seconds ~/ 3600).toString().padLeft(2, "0");
    String m = ((_seconds ~/ 60) % 60).toString().padLeft(2, "0");
    String s = (_seconds % 60).toString().padLeft(2, "0");
    return "$h:$m:$s";
  }
}
