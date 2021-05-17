import 'package:bluff/screens/roomScreen.dart';
import 'package:flutter/material.dart';

// import './screens/logIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluff',
      home: RoomScreen(),
    );
  }
}
