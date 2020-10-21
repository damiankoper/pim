import AsyncStorage from '@react-native-community/async-storage';
import React, {useEffect, useRef, useState} from 'react';
import {StyleSheet, ToastAndroid, View} from 'react-native';
import {Text, useTheme} from 'react-native-paper';
import moment from 'moment';
import {NavigationAction, StackActions} from '@react-navigation/native';

import {FlatList} from 'react-native-gesture-handler';
import _ from 'lodash';
import GameCard, {GameCardStatus} from './GameCard';
import GameCardComponent from './GameCardComponent';
import {RouteProp} from '@react-navigation/native';
import {StackNavigationProp} from '@react-navigation/stack';
import {RootStackParamList} from '../App';

type MenuScreenRouteProp = RouteProp<RootStackParamList, 'Game'>;
type MenuScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Game'>;
type NavigationProps = {
  route: MenuScreenRouteProp;
  navigation: MenuScreenNavigationProp;
};

const GameComponent = ({navigation}: NavigationProps) => {
  const {colors} = useTheme();
  const start = useRef(moment());
  const [timeFormatted, setTimeFormatted] = useState('00:00:00');
  const [counterHits, setCounterHits] = useState(0);
  const [counterAll, setCounterAll] = useState(0);
  const [gameCards, setGameCards] = useState<GameCard[]>([]);
  const [clicked, setClicked] = useState<[GameCard | null, GameCard | null]>([
    null,
    null,
  ]);
  const [duringClickTimeout, setDuringClickTimeout] = useState(false);
  let cards = useRef(-1);
  const getCardsStorage = async () => {
    const value = await AsyncStorage.getItem('cards');
    return value ? parseInt(value, 10) : 12;
  };

  useEffect(() => {
    let gameInterval = setInterval(() => {
      const now = moment.utc();
      setTimeFormatted(moment.utc(now.diff(start.current)).format('HH:mm:ss'));
    }, 1000);

    getCardsStorage().then((_cards) => {
      cards.current = _cards;
      const generatedCards: GameCard[] = [];
      for (let i = 0; i < cards.current / 2; i++) {
        generatedCards.push(new GameCard(i + 1));
      }
      generatedCards.forEach((card) => {
        const newCard = new GameCard(card.number);
        generatedCards.push(newCard);
        newCard.pair = card;
        card.pair = newCard;
      });
      setGameCards(_.shuffle(generatedCards));
    });

    return () => {
      if (gameInterval) {
        clearInterval(gameInterval);
      }
    };
  }, []);

  function handleClicked(card: GameCard) {
    if (!duringClickTimeout) {
      card.state = GameCardStatus.SHOWN;
      if (clicked[0] == null) {
        setClicked([card, null]);
      } else if (card !== clicked[0]) {
        setClicked([clicked[0], card]);
        setDuringClickTimeout(true);
        setTimeout(() => {
          setCounterAll(counterAll + 1);
          if (clicked[0] && clicked[0].pair === card) {
            setCounterHits(counterHits + 1);
            card.state = GameCardStatus.REMOVED;
            clicked[0].state = GameCardStatus.REMOVED;
          } else if (clicked[0]) {
            card.state = GameCardStatus.HIDDEN;
            clicked[0].state = GameCardStatus.HIDDEN;
          }
          handleWin();
          setDuringClickTimeout(false);
          setClicked([null, null]);
          setGameCards([...gameCards]);
        }, 1000);
      }
    }
    setGameCards([...gameCards]);
  }

  function handleWin() {
    if (counterHits + 1 === cards.current / 2) {
      navigation.goBack();
      ToastAndroid.showWithGravity(
        `Nice! You scored ${counterHits}/${counterAll} in ${timeFormatted}!`,
        ToastAndroid.LONG,
        ToastAndroid.BOTTOM,
      );
    }
  }

  return (
    <View style={{...styles.container, backgroundColor: colors.background}}>
      <View style={styles.statsContainer}>
        <Text style={styles.text}>Time: {timeFormatted}</Text>
        <Text style={styles.text}>
          Points: {counterHits}/{counterAll}
        </Text>
      </View>
      <View style={styles.cardsContainer}>
        <FlatList
          style={styles.list}
          numColumns={4}
          data={gameCards}
          renderItem={(card) => (
            <GameCardComponent
              card={card.item}
              state={card.item.state}
              onPress={handleClicked}
            />
          )}
          keyExtractor={(c, i) => i.toString()}
        />
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 16,
  },
  text: {
    fontSize: 24,
    fontWeight: 'bold',
  },
  statsContainer: {
    justifyContent: 'space-between',
    flexDirection: 'row',
  },
  cardsContainer: {
    justifyContent: 'space-evenly',
    flex: 1,
  },
  list: {
    flexGrow: 0,
  },
});
export default GameComponent;
