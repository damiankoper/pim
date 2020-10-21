import {RouteProp} from '@react-navigation/native';
import {StackNavigationProp} from '@react-navigation/stack';
import React from 'react';
import {StyleSheet, View} from 'react-native';
import {Button, Text, useTheme} from 'react-native-paper';
import {RootStackParamList} from './App';

type MenuScreenRouteProp = RouteProp<RootStackParamList, 'Menu'>;
type MenuScreenNavigationProp = StackNavigationProp<RootStackParamList, 'Menu'>;
type NavigationProps = {
  route: MenuScreenRouteProp;
  navigation: MenuScreenNavigationProp;
};

const MenuComponent = ({navigation}: NavigationProps) => {
  const {colors} = useTheme();
  return (
    <View style={{...styles.container, backgroundColor: colors.background}}>
      <View style={styles.titleContainer}>
        <Text style={styles.title}>Memory</Text>
        <Text style={styles.subtitle}>
          simple game to get engeneering degree
        </Text>
      </View>
      <View style={styles.buttonsContainer}>
        <Button
          contentStyle={styles.btn}
          style={styles.marginRight}
          mode="contained"
          onPress={() => navigation.navigate({name: 'Game', params: {}})}>
          Play
        </Button>

        <Button
          contentStyle={styles.btn}
          mode="contained"
          onPress={() => navigation.navigate({name: 'Options', params: {}})}>
          Options
        </Button>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    justifyContent: 'space-evenly',
    alignItems: 'center',
    flex: 1,
  },
  titleContainer: {
    alignItems: 'center',
  },
  title: {
    fontSize: 64,
    fontWeight: 'bold',
  },
  subtitle: {},
  buttonsContainer: {
    flexDirection: 'row',
    justifyContent: 'space-evenly',
  },
  btn: {
    width: 100,
    height: 100,
    alignItems: 'center',
    justifyContent: 'center',
    alignContent: 'stretch',
  },
  marginRight: {
    marginRight: 8,
  },
});
export default MenuComponent;
