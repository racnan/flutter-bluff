import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import './mainGameScreen.dart';

import '../widgets/listOnlineScroll.dart';
import '../widgets/cardOnline.dart';
import '../widgets/button.dart';

class RoomScreen extends StatefulWidget {
  final String username;

  const RoomScreen({this.username});

  @override
  _RoomScreenState createState() => _RoomScreenState();
}

// enum for the room state
// inactive: no one is in the room, user gets to be the host
// waiting: room is active but the game is not started
// active: game is active hence the user cannot join now
// error: default state
enum roomState { inactive, active, waiting, error }

class _RoomScreenState extends State<RoomScreen> {
  // intialize the socketed connection with the server
  IO.Socket socket = IO.io('http://192.168.1.38:3000/room', <String, dynamic>{
    'transports': ['websocket'],
  });

  // disconnect the Socket connection when the user leaves
  @override
  void dispose() {
    print("Screen2: dispose");
    socket.io.disconnect();
    super.dispose();
  }

  // keeps track of the current room state
  var currRoomState = roomState.inactive;

  // used for first initialization, this is set to false
  // after the screen is initialized in "build" method
  bool initialized = false;

  // name of the players
  List listOfPlayers = [];

  // name of the host
  String host;

  // number of decks to be used in the game
  var numberOfDecks = 1;

  // number of players
  var numberOfPlayers = 1;

  // cards per player
  var cardsPerPlayers = 1;

  // for entering number of cards per player
  final _formKey = GlobalKey<FormState>();
  final TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // this is done so that socket.emit() is only executed for first build
    // otherwise, with every setState() socket.emit('join) will be called which
    // will again cause a rebuild.[Looped]
    if (!initialized) {
      initialized = true;
      socket.emit('join', widget.username);
    }

    // server sends the state of the room after receiving "join"
    // or when a user disconnected
    socket.on('join-resp', (data) {
      // data is an array
      // data[0]: state of the game,
      // data[1]: array of the name of the players in the room
      // data[2]: host
      // data[3]: numberOfDecks
      // data[4]: cards per player
      print("RS: $data");
      setState(() {
        if (data[0] == "active") {
          currRoomState = roomState.active;
          listOfPlayers = data[1];
        } else if (data[0] == "inactive") {
          currRoomState = roomState.inactive;
          listOfPlayers = data[1];
          numberOfDecks = data[3];
          cardsPerPlayers = data[4];
          host = widget.username;
          numberOfPlayers = listOfPlayers.length;
        }

        // if the state is waiting and user is not the host
        else if (data[0] == "waiting" && (data[2] != widget.username)) {
          currRoomState = roomState.waiting;
          listOfPlayers = data[1];
          numberOfDecks = data[3];
          cardsPerPlayers = data[4];
          numberOfPlayers = listOfPlayers.length;
        }

        // if the state is waiting and user is the host
        else if (data[0] == "waiting" && data[2] == widget.username) {
          currRoomState = roomState.inactive;
          listOfPlayers = data[1];
          numberOfDecks = data[3];
          cardsPerPlayers = data[4];
          host = widget.username;
          numberOfPlayers = listOfPlayers.length;
        }
      });
    });

    socket.on('start-resp', (_) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GameScreen(
                    username: widget.username,
                  )));
    });

    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 50.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: returnStateScreen(screenWidth, screenHeight));
  }

  // returns the body of the screen according to the current state
  Widget returnStateScreen(double screenWidth, double screenHeight) {
    if (currRoomState == roomState.active) {
      return activeState(screenWidth);
    } else if (currRoomState == roomState.inactive) {
      return inactiveState(screenWidth, screenHeight);
    } else if (currRoomState == roomState.waiting) {
      return waitingState(screenWidth, screenHeight);
    } else
      return errorState(screenWidth);
  }

  // default state, just displays error text
  Widget errorState(double screenWidth) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "Oops! something went wrong. Please wait or try again later.",
          style: TextStyle(
              fontSize: screenWidth * 0.03,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget activeState(double screenWidth) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          "Please wait for the next game to start!",
          style: TextStyle(
              fontSize: screenWidth * 0.04,
              color: Colors.black,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // state when user is the host
  Widget inactiveState(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: screenHeight / 2,
            width: screenWidth,
            // color: Colors.red,
            child: hostControl(screenWidth, screenHeight),
          ),
          Container(
            height: screenHeight / 2,
            width: screenWidth,
            // color: Colors.blue,
            child: OnlineScroller(
              widgetList:
                  listOfPlayers.map((name) => CardOnline(name: name)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget waitingState(double screenWidth, double screenHeight) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: screenHeight / 3,
            width: screenWidth,
            child: nonHostDisplay(),
          ),
          Container(
            height: (2 * screenHeight) / 3,
            width: screenWidth,
            // color: Colors.blue,
            child: OnlineScroller(
              widgetList:
                  listOfPlayers.map((name) => CardOnline(name: name)).toList(),
            ),
          )
        ],
      ),
    );
  }

  // the upper part of the host screen
  // with deck control

  Widget hostControl(double screenWidth, double screenHeight) {
    return Center(
      // color: Colors.amber,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Number of decks and its drop down menu
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  // color: Colors.red,
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Number of decks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              Container(
                padding: EdgeInsets.all(8),
                // color: Colors.blue,
                child: DropdownButton<int>(
                  value: numberOfDecks,
                  onChanged: (value) {
                    setState(() {
                      numberOfDecks = value;
                    });
                  },
                  items:
                      <int>[1, 2, 3, 4].map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
              ),
            ]),
            // Cards per player
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Cards per player :",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              Container(
                  height: 60,
                  width: 60,
                  // color: Colors.amber,
                  // padding: EdgeInsets.all(8),
                  child: Form(
                      key: _formKey,
                      child: TextFormField(
                        cursorColor: Colors.black,
                        textAlign: TextAlign.center,
                        controller: textController,
                        validator: (value) {
                          int tmp;
                          try {
                            tmp = int.parse(value);
                          } catch (_) {
                            return "invalid";
                          }

                          if (tmp < 1 ||
                              tmp >
                                  ((numberOfDecks * 52) / numberOfPlayers)
                                      .floor()) {
                            return "invalid";
                          } else {
                            return null;
                          }
                        },
                      ))),
            ]),
            Container(
              margin: EdgeInsets.all(5),
              child: CustomButtom(
                text: "Set",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    cardsPerPlayers = int.parse(textController.text);
                    socket
                        .emit('update-decks', [numberOfDecks, cardsPerPlayers]);
                  }
                },
                height: screenHeight / 20,
                width: screenWidth / 5,
              ),
            ),
            Container(
              // padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 20),
              child: CustomButtom(
                text: "Start",
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    cardsPerPlayers = int.parse(textController.text);
                    socket.emit('start', [numberOfDecks, cardsPerPlayers]);
                  }
                },
                height: screenHeight / 20,
                width: screenWidth / 5,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget nonHostDisplay() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Number of decks",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    numberOfDecks.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Cards per player:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    cardsPerPlayers.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
            ]),
          ],
        ),
      ),
    );
  }
}
