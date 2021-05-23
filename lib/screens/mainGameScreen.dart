import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import './checkCards.dart';

import '../widgets/listOnlineScroll.dart';
import '../widgets/cardOnline.dart';
import '../widgets/button.dart';

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
  var mainGameList = [
    ["abc", 24],
    ["xyz", 9]
  ];

  String currentNumber = '0';

  // true if current turn is users
  var userTurn = false;

  // if user can check the turn before
  var userCheck = false;

  //
  var showCards = false;

  @override
  Widget build(BuildContext context) {
    // this is done so that socket.emit() is only executed for first build
    // otherwise, with every setState() socket.emit('join) will be called which
    // will again cause a rebuild.[Looped]
    if (!initialized) {
      socket.emit('intialize', widget.username);
      initialized = true;
    }

    // response to intialize function
    // data[0] -> [[username, cardsleft], ...]
    socket.on('intialize-resp', (data) {
      print(data);
      setState(() {
        mainGameList = data;
      });
    });

    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 20.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              // color: Colors.blue,
              height: screenHeight / 2,
              width: screenWidth,
              child: upperDisplay(screenHeight, screenWidth)),
          Container(
            height: screenHeight / 2,
            width: screenWidth,
            // color: Colors.red,
            child: OnlineScroller(
              widgetList: mainGameList
                  .map((data) => CardOnline(
                        name: data[0],
                        cardsLeft: data[1],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    ));
  }

  Widget upperDisplay(double screenHeight, double screenWidth) {
    if (userTurn && userCheck) {
      return checkDisplay(screenHeight, screenWidth);
    } else if (userTurn && !userCheck) {
      return turnDisplay(screenHeight, screenWidth);
    } else {
      return normalDisplay(screenHeight, screenWidth);
    }
  }

  Widget checkDisplay(double screenHeight, double screenWidth) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (currentNumber != '1')
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'चाल : $currentNumber',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: screenHeight * 0.03),
                    )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 3,
                    onPressed: () {},
                    text: "Check Cards",
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {
                      setState(() {
                        userCheck = false;
                      });
                    },
                    text: "Play",
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {},
                    text: "Bluff",
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {},
                    text: "पास",
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget turnDisplay(double screenHeight, double screenWidth) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (currentNumber == '0')
                Container(
                    margin: EdgeInsets.all(10),
                    child: CustomButtom(
                      height: screenHeight / 20,
                      width: screenWidth / 3,
                      onPressed: () {},
                      text: "Select चाल",
                    )),
              if (currentNumber != '0')
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      //TODO: Turn this into hindi
                      'चाल : $currentNumber',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: screenHeight * 0.03),
                    )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 3,
                    onPressed: () {},
                    text: "Check Cards",
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {},
                    text: "Play Fair",
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {},
                    text: "Bluff",
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget normalDisplay(double screenHeight, double screenWidth) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'चाल : $currentNumber',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: screenHeight * 0.03),
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 3,
                    onPressed: () {},
                    text: "Check Cards",
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
