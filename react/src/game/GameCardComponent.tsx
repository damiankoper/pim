import {Image, Pressable, StyleSheet} from 'react-native';
import React from 'react';
import GameCard, {GameCardStatus, resources} from './GameCard';
import Icon from 'react-native-vector-icons/MaterialCommunityIcons';

interface Props {
  card: GameCard;
  state: GameCardStatus;
  onPress: (card: GameCard) => void;
}

const GameCardComponent: React.FunctionComponent<Props> = (props: Props) => {
  let image;
  switch (props.state) {
    case GameCardStatus.SHOWN:
      const src = (resources as any)[props.card.number];
      image = <Image source={src} style={styles.image} />;
      break;
    case GameCardStatus.HIDDEN:
      image = <Icon name="image" color="white" style={styles.icon} />;
      break;
    case GameCardStatus.REMOVED:
      image = null;
      break;
  }
  return (
    <Pressable
      onPress={() =>
        props.state !== GameCardStatus.REMOVED
          ? props.onPress(props.card)
          : null
      }
      style={{...styles.container}}>
      {image}
    </Pressable>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 4,
    aspectRatio: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  icon: {fontSize: 92},
  image: {flex: 1, width: '100%', aspectRatio: 1},
});
export default GameCardComponent;
