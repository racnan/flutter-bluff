import 'package:flutter/material.dart';

// import './screens/logIn.dart';
// import './screens/roomScreen.dart';
import './screens/mainGameScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluff',
      home: GameScreen(),
    );
  }
}
