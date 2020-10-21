import {StyleSheet, View} from 'react-native';
import React from 'react';
import {Button, List, Menu, Switch, useTheme} from 'react-native-paper';
import AsyncStorage from '@react-native-community/async-storage';

const OptionsComponent = () => {
  const [isSwitchOn, setIsSwitchOn] = React.useState(false);
  const [cards, setCards] = React.useState(12);
  const [menuVisible, setMenuVisible] = React.useState(false);
  const getCardsStorage = async () => {
    const value = await AsyncStorage.getItem('cards');
    if (value !== null) {
      setCards(parseInt(value, 10));
    }
  };
  const setCardsStorage = async (newCards: number) => {
    await AsyncStorage.setItem('cards', newCards.toString());
    setMenuVisible(false);
  };
  getCardsStorage();

  const onToggleSwitch = () => setIsSwitchOn(!isSwitchOn);
  const {colors} = useTheme();

  return (
    <View style={{...styles.container, backgroundColor: colors.background}}>
      <List.Section>
        <List.Subheader>General</List.Subheader>
        <List.Item
          title="Cards"
          onPress={() => setMenuVisible(true)}
          left={() => <List.Icon icon="image-multiple" />}
          right={() => (
            <View style={styles.cardsContainer}>
              <Menu
                visible={menuVisible}
                onDismiss={() => setMenuVisible(false)}
                anchor={
                  <Button onPress={() => setMenuVisible(true)}>{cards}</Button>
                }>
                <Menu.Item onPress={() => setCardsStorage(12)} title="12" />
                <Menu.Item onPress={() => setCardsStorage(16)} title="16" />
                <Menu.Item onPress={() => setCardsStorage(20)} title="20" />
              </Menu>
            </View>
          )}
        />

        <List.Item
          onPress={onToggleSwitch}
          title="Calm down, more to come..."
          left={() => <List.Icon icon="cog" />}
          right={() => (
            <Switch value={isSwitchOn} onValueChange={onToggleSwitch} />
          )}
        />
      </List.Section>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  cardsContainer: {
    justifyContent: 'center',
    alignItems: 'flex-end',
    flex: 1,
  },
  cardsText: {
    fontWeight: 'bold',
    fontSize: 16,
    marginRight: 8,
  },
});
export default OptionsComponent;
