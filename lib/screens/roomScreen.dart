import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class RoomScreen extends StatefulWidget {
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
  var currRoomState = roomState.inactive;

  // used for first initialization, this is set to false
  // after the screen if initialized in "build" method
  bool initialized = false;

  @override
  Widget build(BuildContext context) {
    // this is done so that socket.emit() is only executed for first build
    // otherwise, with every setState() socket.emit() will be called which
    // will rebuild setting of socket.emit() again.[Looped]
    if (!initialized) {
      socket.emit('join', 'room1');
      initialized = true;
    }

    // server sends the state of the room after receiving "join"
    // data received is a string
    socket.on('join-resp', (data) {
      // rebuild wiht new room state
      setState(() {
        if (data == "active") {
          currRoomState = roomState.active;
        } else if (data == "inactive") {
          currRoomState = roomState.inactive;
        } else if (data == "waiting") {
          currRoomState = roomState.waiting;
        }
      });
    });

    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight = MediaQuery.of(context).size.height.roundToDouble();
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Scaffold(body: returnStateScreen(screenWidth, screenHeight));
  }

  // returns the body of the screen according to the current state
  Widget returnStateScreen(double screenWidth, double screenHeight) {
    if (currRoomState == roomState.active) {
      return activeState(screenWidth);
    } else if (currRoomState == roomState.inactive) {
      return inactiveState();
    } else if (currRoomState == roomState.waiting) {
      return waitingState();
    } else
      return errorState(screenWidth);
  }

  // default state, just displays error text
  Widget errorState(double screenWidth) {
    return Center(
      child: Text(
        "Oops! something went wrong. Please wait or try again later.",
        style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget activeState(double screenWidth) {
    return Center(
      child: Text(
        "Please wait for the next game to start!",
        style: TextStyle(
            fontSize: screenWidth * 0.04,
            color: Colors.black,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  // state when user is the host
  Widget inactiveState() {
    return Container(
      color: Colors.cyan,
    );
  }

  Widget waitingState() {
    return Container(
      color: Colors.green,
    );
  }
}

/* Scaffold(
        body: FutureBuilder<String>(
      future: s.main(),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        print(snapshot.data);
        if (snapshot.hasData) {
          if (snapshot.data == "active") {
            return activeState();
          } else if (snapshot.data == "inactive") {
            return inactiveState();
          } else if (snapshot.data == "waiting") {
            return waitingState();
          }
        } else if (snapshot.hasError) {
          return Center(
              child: Text("An error occureed! Please try later",
                  style: TextStyle(
                      fontSize: screenWidth * 0.03,
                      color: Colors.red,
                      fontWeight: FontWeight.bold)));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
      },
    )); */
