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

const assetPrefix = "./lib/assets/images/";
const CardResources = {
  1: assetPrefix + "i011_carrot.png",
  2: assetPrefix + "i012_owl.png",
  3: assetPrefix + "i013_corn.png",
  4: assetPrefix + "i020_chestnut.png",
  5: assetPrefix + "i014_orange.png",
  6: assetPrefix + "i015_pear.png",
  7: assetPrefix + "i016_fig.png",
  8: assetPrefix + "i017_pomegranate.png",
  9: assetPrefix + "i018_bee.png",
  10: assetPrefix + "i019_bear.png",
};

class GameCardWidget extends StatelessWidget {
  GameCard _card;
  Function(GameCard card) _onTap = (GameCard card) => {};
  GameCardWidget({Key key, GameCard card, Function(GameCard card) onTap})
      : super(key: key) {
    _card = card;
    _onTap = onTap;
  }

  @override
  Widget build(BuildContext context) {
    switch (_card.type) {
      case CardType.HIDDEN:
        return GestureDetector(
          onTap: () => _onTap(_card),
          child: new FittedBox(
            fit: BoxFit.fill,
            child: new Icon(Icons.image),
          ),
        );
      case CardType.REMOVED:
        return Container();
      case CardType.SHOWN:
        return Container(
            margin: EdgeInsets.all(4),
            child: Image.asset(CardResources[_card.number]));
    }
  }
}
