import 'package:flutter/material.dart';

import '../controllers/roomScreenSocket.dart' as s;

class RoomScreen extends StatefulWidget {
  @override
  _RoomScreenState createState() => _RoomScreenState();
}

enum roomState { inactive, active, waiting }

class _RoomScreenState extends State<RoomScreen> {
  var currRoomState = roomState.active;

  @override
  Widget build(BuildContext context) {
    s.main();
    return Scaffold(
        body: currRoomState == roomState.active
            ? activeState()
            : (currRoomState == roomState.inactive
                ? inactiveState()
                : waitingState()));
  }

  Widget activeState() {
    return Container(
      color: Colors.amber,
    );
  }

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
