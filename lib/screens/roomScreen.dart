import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../widgets/listOnlineScroll.dart';
import '../widgets/cardOnline.dart';

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
  IO.Socket socket = IO.io('http://localhost:3000/room', <String, dynamic>{
    'transports': ['websocket'],
  });

  // keeps track of the current room state
  var currRoomState = roomState.error;

  // used for first initialization, this is set to false
  // after the screen if initialized in "build" method
  bool initialized = false;

  // name of the players
  List listOfPlayers = [];

  //name of the host
  String host;

  @override
  Widget build(BuildContext context) {
    // this is done so that socket.emit() is only executed for first build
    // otherwise, with every setState() socket.emit() will be called which
    // will rebuild setting of socket.emit() again.[Looped]

    if (!initialized) {
      socket.emit('join', widget.username);
      initialized = true;
    }

    // server sends the state of the room after receiving "join"
    // or when a user disconnected
    socket.on('join-resp', (data) {
      // rebuild with new room state
      print(widget.username);
      print(data);
      setState(() {
        if (data[0] == "active") {
          currRoomState = roomState.active;
          listOfPlayers = data[1];
        } else if (data[0] == "inactive") {
          currRoomState = roomState.inactive;
          listOfPlayers = data[1];
          host = widget.username;
        }
        // if the state is waiting and user is not the host
        else if (data[0] == "waiting" && (data[2] != widget.username)) {
          currRoomState = roomState.waiting;
          listOfPlayers = data[1];
        }
        // if the state is waiting and user is the host
        else if (data[0] == "waiting" && data[2] == widget.username) {
          currRoomState = roomState.inactive;
          listOfPlayers = data[1];
        }
      });
    });

    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 50.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Scaffold(body: returnStateScreen(screenWidth, screenHeight));
  }

  // returns the body of the screen according to the current state
  Widget returnStateScreen(double screenWidth, double screenHeight) {
    if (currRoomState == roomState.active) {
      return activeState(screenWidth);
    } else if (currRoomState == roomState.inactive) {
      return inactiveState(screenWidth, screenHeight);
    } else if (currRoomState == roomState.waiting) {
      return waitingState();
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
            height: screenHeight / 3,
            width: screenWidth,
            // color: Colors.red,
          ),
          Container(
            height: (2 * screenHeight) / 3,
            width: screenWidth,
            // color: Colors.blue,
            child: OnlineScroller(
              widgetList: listOfPlayersOnline(),
            ),
          )
        ],
      ),
    );
  }

  Widget waitingState() {
    return Container(
      color: Colors.green,
    );
  }

  List<Widget> listOfPlayersOnline() {
    return listOfPlayers.map((name) => CardOnline(name: name)).toList();
  }
}
