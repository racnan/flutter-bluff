import 'package:flutter/material.dart';

import '../models/cards.dart';

class CheckCards extends StatelessWidget {
  final List cards;

  CheckCards({@required this.cards});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 20.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Container(
      child: ListView.builder(
          itemCount: cards.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black)),
              // color: Colors.red,
              margin: EdgeInsets.all(2),
              height: screenHeight / 15,
              width: screenWidth / 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text(
                      "${NumberCards[cards[index][0]]}",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    child: Text(
                      " x${cards[index][1]}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
