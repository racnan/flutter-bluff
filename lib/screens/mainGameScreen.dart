import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../widgets/listOnlineScroll.dart';
import '../widgets/cardOnline.dart';

class GameScreen extends StatefulWidget {
  final String username;

  const GameScreen({this.username});
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // intialize the socketed connection with the server
  IO.Socket socket = IO.io('http://localhost:3000/game', <String, dynamic>{
    'transports': ['websocket'],
  });

  // used for first initialization, this is set to false
  // after the screen is initialized in "build" method
  var initialized = false;

  // list with username and cards left arranged according turns.
  var mainGameList = [];

  @override
  Widget build(BuildContext context) {
    if (!initialized) {
      socket.emit('intialize', widget.username);
      initialized = true;
    }

    socket.on('intialize-resp', (data) {
      print(data);
      setState(() {
        mainGameList = data;
      });
    });

    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 50.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Container(
      height: (2 * screenHeight) / 3,
      width: screenWidth,
      // color: Colors.blue,
      child: OnlineScroller(
        widgetList: mainGameList
            .map((data) => CardOnline(
                  name: data[0],
                  cardsLeft: data[1],
                ))
            .toList(),
      ),
    );
  }
}
