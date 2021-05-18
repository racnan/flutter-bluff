// import 'package:bluff/screens/roomScreen.dart';
import 'package:flutter/material.dart';

import './screens/logIn.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bluff',
      home: LoginScreen(),
    );
  }
}
