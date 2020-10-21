import React from 'react';
import {NavigationContainer} from '@react-navigation/native';
import {createStackNavigator} from '@react-navigation/stack';
import {DarkTheme, Provider as PaperProvider} from 'react-native-paper';
import MenuComponent from './Menu';
import OptionsComponent from './Options';
import GameComponent from './game/Game';
const Stack = createStackNavigator();

export type RootStackParamList = {
  Menu: {};
  Options: {};
  Game: {};
};

const App = () => {
  return (
    <PaperProvider theme={DarkTheme}>
      <NavigationContainer>
        <Stack.Navigator headerMode="none">
          <Stack.Screen name="Menu" component={MenuComponent} />
          <Stack.Screen name="Options" component={OptionsComponent} />
          <Stack.Screen name="Game" component={GameComponent} />
        </Stack.Navigator>
      </NavigationContainer>
    </PaperProvider>
  );
};

export default App;
