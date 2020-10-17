// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:memory/game/gameCard.dart';
import 'package:preferences/preference_service.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
  Timer _timerTap;
  List<GameCard> _gameCards = [];
  List<GameCard> _clicked = [null, null];

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
    _cards = int.parse(
        PrefService.sharedPreferences.getString('pref_cards') ?? "12");
    for (var i = 1; i <= _cards / 2; i++) {
      var card = GameCard(i);
      _gameCards.add(card);
    }

    List<GameCard> pairs = [];
    for (GameCard card in _gameCards) {
      var pairCard = GameCard(card.number);
      card.pair = pairCard;
      pairCard.pair = card;
      pairs.add(pairCard);
    }
    _gameCards.addAll(pairs);
    _gameCards.shuffle();
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  void handleTap(GameCard card) {
    if (_timerTap == null || !_timerTap.isActive) {
      setState(() {
        card.type = CardType.SHOWN;
        if (_clicked[0] == null) {
          _clicked[0] = card;
        } else {
          _clicked[1] = card;
          _counterAll++;
          _timerTap = Timer(new Duration(seconds: 1), () {
            setState(() {
              if (_clicked[0].pair == card) {
                _counterHits++;
                _clicked[0].type = CardType.REMOVED;
                _clicked[1].type = CardType.REMOVED;
              } else {
                _clicked[0].type = CardType.HIDDEN;
                _clicked[1].type = CardType.HIDDEN;
              }
              _clicked = [null, null];
              if (_counterHits == _cards / 2) {
                handleWin();
              }
            });
          });
        }
      });
    }
  }

  void handleWin() {
    _timer.cancel();
    Fluttertoast.showToast(
      msg: "Nice! You scored $_counterHits/$_counterAll in ${getTimeString()}",
      toastLength: Toast.LENGTH_LONG,
    );
    Navigator.pop(context);
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(16),
                            child: GridView.count(
                              shrinkWrap: true,
                              primary: true,
                              crossAxisCount: 4,
                              mainAxisSpacing: 4,
                              crossAxisSpacing: 4,
                              children: _gameCards
                                  .map((card) => GameCardWidget(
                                      card: card, onTap: handleTap))
                                  .toList(),
                            ),
                          ),
                        )
                      ],
                    ),
                  ],
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
