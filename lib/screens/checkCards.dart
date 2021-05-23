import 'package:flutter/material.dart';

import '../models/cards.dart';

class CheckCards extends StatelessWidget {
  final List cards;
  final int numberOfCards;

  CheckCards({@required this.cards, this.numberOfCards});

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 20.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Container(
      child: ListView.builder(
          itemCount: numberOfCards,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(2),
              height: screenHeight / 15,
              width: screenWidth,
              child: Row(
                children: [
                  Container(
                    child: Text("${NumberCards[cards[index][0]]}"),
                  ),
                  Container(
                    child: Text("${cards[index][1]}"),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
