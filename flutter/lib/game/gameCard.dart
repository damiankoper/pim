import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum CardType {
  SHOWN,
  HIDDEN,
  REMOVED,
}

class GameCard {
  int number = 0;
  CardType type = CardType.HIDDEN;
  GameCard pair;
  GameCard(this.number);
}

class GameCardWidget extends StatelessWidget {
  GameCard _card;
  GameCardWidget({Key key, GameCard card}) : super(key: key) {
    _card = card;
  }

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.image);
  }
}
