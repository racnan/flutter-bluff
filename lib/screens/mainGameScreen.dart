import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../models/cards.dart';

import '../widgets/listOnlineScroll.dart';
import '../widgets/cardOnline.dart';
import '../widgets/customButton.dart';
import '../widgets/checkCards.dart';

class GameScreen extends StatefulWidget {
  final String username;

  const GameScreen({Key key, this.username}) : super(key: key);
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // intialize the socketed connection with the server
  IO.Socket socket = IO.io('http://192.168.1.38:3000/game', <String, dynamic>{
    'transports': ['websocket'],
  });

  // disconnect the Socket connection when the user leaves
  @override
  void dispose() {
    print("MG: dispose");
    socket.dispose();
    super.dispose();
  }

  // used for first initialization, this is set to false
  // after the screen is initialized in "build" method
  var initialized = false;

  // list with username and cards left arranged according turns.
  var mainGameList = [
    /* ["abc", 2],
    ["xyz", 6],
    ["abc", 2],
    ["xyz", 6],
    ["abc", 2],
    ["xyz", 6], */
  ];

  // the current "chaal"
  int currentChaal;

  // show this screen if the its first turn of chaal
  var firstTurn = false;

  // true if current turn is users
  var userTurn = false;

  // if user can check the turn before
  var userCheck = false;

  // shows the chaal select screen when true
  var chaalSelect = false;

  // display cards
  var showCards = false;

  // display playbluff screen
  var playBluff = false;

  // display playFair screen
  var playFair = false;

  // userdeck in numbers
  var userDeck = [
    /* 1,
    26,
    6,
    21,
    34,
    33,
    51, */
  ];

  // orderdeck to show in "Check Cards"
  var orderedDeck = [
    /* [1, 3],
    [2, 5],
    [1, 6],
    [1, 7],
    [1, 8],
    [1, 9],
    [1, 10], */
  ];

  var playBluffSelectedCardsIndex = <int>[];

  // play fair quantity
  var playFairQuant = 1;

  @override
  Widget build(BuildContext context) {
    // when idle, the sockets dissconnect and then reconnects automatically
    // this function will send the username to server upon reconnection
    socket.onReconnect((data) => socket.emit("reconnectt", widget.username));

    // this is done so that socket.emit() is only executed for first build
    // otherwise, with every setState() socket.emit('join) will be called which
    // will again cause a rebuild.[Looped]
    if (!initialized) {
      initialized = true;
      socket.emit('intialize', widget.username);
    }

    // response to intialize function
    // data[0] -> [[username, cardsleft], ...]
    // data[1] -> [2,34,6,...] deck of the user
    // data[2] -> [[1,3],[13,2],...] ordered deck
    // data[3] -> "username" current turn
    // data[4] -> bool isfirstTurn
    socket.on('intialize-resp', (data) {
      setState(() {
        mainGameList = data[0];
        userDeck = data[1];
        orderedDeck = data[2];

        if (data[3] == widget.username) {
          userTurn = true;

          firstTurn = data[4];
          userCheck = !data[4];
        } else {
          userTurn = false;
        }
      });
    });

    socket.on('chaal-select-resp', (data) {
      print("chaal-sel-reso");
      setState(() {
        currentChaal = data;
      });
    });

    socket.on('played-resp', (data) {
      print("MG: played resp");
      setState(() {
        mainGameList = data[0];
        userDeck = data[1];
        orderedDeck = data[2];
      });
    });

    socket.on('played', (data) {
      print("MG: played");
      print(data);
      setState(() {
        mainGameList = data[0];

        if (data[1] == widget.username) {
          userTurn = true;

          firstTurn = data[2];
          userCheck = !data[2];
        } else {
          userTurn = false;
        }
      });
    });

    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 20.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Scaffold(
        backgroundColor: Colors.blueGrey[50],
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                // color: Colors.blue,
                height: screenHeight / 2,
                width: screenWidth,
                child: upperDisplay(screenHeight, screenWidth),
              ),
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
    // secondary display
    if (showCards) {
      // part of every display
      return showCardsDisplay(screenHeight, screenWidth);
    } else if (chaalSelect) {
      // part of first turn display
      return chaalDisplay(screenHeight, screenWidth);
    } else if (playBluff) {
      // Part of turnDisplay and firstTurnDisplay
      return playBluffDisplay(screenHeight, screenWidth);
    } else if (playFair) {
      // Part of turnDisplay and firstTurnDisplay
      return playFairDisplay(screenHeight, screenWidth);
    }

    // Primary display
    else if (firstTurn) {
      return firstTurnDisplay(screenHeight, screenWidth);
    } else if (userCheck) {
      return checkDisplay(screenHeight, screenWidth);
    } else if (userTurn) {
      return turnDisplay(screenHeight, screenWidth);
    } else {
      return nonTurnDisplay(screenHeight, screenWidth);
    }
  }

// -------------- SECONDARY DISPLAYS --------------
// below displays are for upper half of the screen
// they are displayed after a button press from the Primary upper display

  Widget playFairDisplay(double screenHeight, double screenWidth) {
    var dropDownNumList = <DropdownMenuItem<int>>[];

    for (var i = 0; i < orderedDeck.length; i++) {
      if (orderedDeck[i][0] == currentChaal) {
        for (var j = 0; j < orderedDeck[i][1]; j++) {
          dropDownNumList.add(DropdownMenuItem<int>(
            value: j + 1,
            child: Text((j + 1).toString()),
          ));
        }
        break;
      }
    }

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              margin: EdgeInsets.all(10),
              child: Text(
                'चाल : ${NumberCards[currentChaal]}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: screenHeight * 0.03),
              )),
          Container(
            padding: EdgeInsets.all(8),
            child: DropdownButton<int>(
              value: playFairQuant,
              onChanged: (value) {
                setState(() {
                  playFairQuant = value;
                });
              },
              items: dropDownNumList,
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: CustomButtom(
              height: screenHeight / 20,
              width: screenWidth / 3,
              text: "Send",
              onPressed: () {
                socket.emit('played-fair', playFairQuant);
                setState(() {
                  playFair = false;
                  userTurn = false;
                  userCheck = false;
                  firstTurn = false;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(8),
            child: CustomButtom(
              height: screenHeight / 20,
              width: screenWidth / 3,
              text: "Back",
              onPressed: () {
                setState(() {
                  playFair = false;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  // Part of turnDisplay and firstTurnDisplay
  Widget playBluffDisplay(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ...playBluffHelper(screenHeight, screenWidth),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            if (playBluffSelectedCardsIndex.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButtom(
                  height: screenHeight / 20,
                  width: screenWidth / 4,
                  onPressed: () {
                    setState(() {
                      playBluffSelectedCardsIndex = [];
                    });
                  },
                  text: "unselect all",
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtom(
                height: screenHeight / 20,
                width: screenWidth / 4,
                onPressed: () {
                  setState(() {
                    playBluff = false;
                    playBluffSelectedCardsIndex = [];
                  });
                },
                text: "Back",
              ),
            ),
            if (playBluffSelectedCardsIndex.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButtom(
                  height: screenHeight / 20,
                  width: screenWidth / 4,
                  onPressed: () {
                    socket.emit('played-bluff', playBluffSelectedCardsIndex);
                    setState(() {
                      playBluff = false;
                      userTurn = false;
                      firstTurn = false;
                      userCheck = false;
                    });
                  },
                  text: "Bluff",
                ),
              ),
          ],
        ),
      ]),
    );
  }

  // part of first turn display
  Widget chaalDisplay(double screenHeight, double screenWidth) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: chaalDisplayRowHelper(
                      [0, 1, 2, 3, 4], screenHeight, screenWidth)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: chaalDisplayRowHelper(
                      [5, 6, 7, 8, 9], screenHeight, screenWidth)),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: chaalDisplayRowHelper(
                      [10, 11, 12], screenHeight, screenWidth)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: CustomButtom(
                height: screenHeight / 20,
                width: screenWidth / 3,
                text: "Back",
                onPressed: () {
                  setState(() {
                    chaalSelect = false;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget showCardsDisplay(double screenHeight, double screenWidth) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Container(
        height: screenHeight / 3,
        child: OnlineScroller(
            widgetList: orderedDeck
                .map((data) => CheckCards(card: data[0], quantity: data[1]))
                .toList()),
      ),
      Container(
        child: CustomButtom(
          height: screenHeight / 15,
          width: screenWidth / 3,
          onPressed: () {
            setState(() {
              showCards = false;
            });
          },
          text: "Back",
        ),
      )
    ]);
  }

// -------------- PRIMARY DISPLAYS --------------
// below displays are for upper half of the screen
// these display leads to secondary upper display by button clicks

  Widget checkDisplay(double screenHeight, double screenWidth) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (currentChaal != null)
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'चाल : ${NumberCards[currentChaal]}',
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
                    onPressed: () {
                      setState(() {
                        showCards = true;
                      });
                    },
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

  Widget firstTurnDisplay(double screenHeight, double screenWidth) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (currentChaal != null)
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'चाल : ${NumberCards[currentChaal]}',
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
                  onPressed: () {
                    setState(() {
                      chaalSelect = true;
                    });
                  },
                  text: "Select चाल",
                )),
            Container(
                margin: EdgeInsets.all(10),
                child: CustomButtom(
                  height: screenHeight / 20,
                  width: screenWidth / 3,
                  onPressed: () {
                    setState(() {
                      showCards = true;
                    });
                  },
                  text: "Check Cards",
                )),
            if (currentChaal != null)
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {
                      setState(() {
                        playFair = true;
                      });
                    },
                    text: "Play Fair",
                  )),
            if (currentChaal != null)
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {
                      setState(() {
                        playBluff = true;
                      });
                    },
                    text: "Bluff",
                  ))
          ],
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
              Container(
                  margin: EdgeInsets.all(10),
                  child: Text(
                    'चाल : ${NumberCards[currentChaal]}}',
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
                    onPressed: () {
                      setState(() {
                        showCards = true;
                      });
                    },
                    text: "Check Cards",
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {
                      setState(() {
                        playFair = true;
                      });
                    },
                    text: "Play Fair",
                  )),
              Container(
                  margin: EdgeInsets.all(10),
                  child: CustomButtom(
                    height: screenHeight / 20,
                    width: screenWidth / 4,
                    onPressed: () {
                      setState(() {
                        playBluff = true;
                      });
                    },
                    text: "Bluff",
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget nonTurnDisplay(double screenHeight, double screenWidth) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (currentChaal != null)
                Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      'चाल : ${NumberCards[currentChaal]}',
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
                    onPressed: () {
                      setState(() {
                        showCards = true;
                      });
                    },
                    text: "Check Cards",
                  )),
            ],
          ),
        ),
      ),
    );
  }

// ------------------ HELPER FUNCTIONS ------------------

  List<Widget> chaalDisplayRowHelper(
      List<int> li, double screenHeight, double screenWidth) {
    var rw = <Widget>[];
    for (var i = 0; i < li.length; i++) {
      rw.add(
        CustomButtom(
          height: screenHeight / 20,
          width: screenWidth / 6,
          onPressed: () {
            setState(() {
              currentChaal = li[i];
              chaalSelect = false;
            });
            socket.emit('chaal-select', li[i]);
          },
          text: "${NumberCards[li[i]]}",
        ),
      );
    }
    return rw;
  }

  List<Widget> playBluffHelper(double screenHeight, double screenWidth) {
    var totalRws = <Widget>[];
    var rw = <Widget>[];
    for (var i = 0; i < userDeck.length; i++) {
      rw.add(Padding(
        padding: const EdgeInsets.all(5.0),
        child: CustomButtom(
            color: playBluffSelectedCardsIndex.contains(i)
                ? Colors.blueGrey
                : null,
            height: screenHeight / 20,
            width: screenWidth / 5,
            onPressed: () {
              setState(() {
                if (playBluffSelectedCardsIndex.contains(i)) {
                  playBluffSelectedCardsIndex.remove(i);
                } else {
                  playBluffSelectedCardsIndex.add(i);
                }
              });
            },
            cardNumber: userDeck[i]),
      ));
      if ((i + 1) % 4 == 0) {
        totalRws.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: rw,
        ));
        rw = <Widget>[];
      }
    }
    if (rw.isNotEmpty) {
      totalRws.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: rw,
      ));
    }
    return totalRws;
  }
}
