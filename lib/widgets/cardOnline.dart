import 'package:flutter/material.dart';

class CardOnline extends StatelessWidget {
  final String name;
  final int cardsLeft;
  final String currentTurn;

  CardOnline({@required this.name, this.cardsLeft, this.currentTurn});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          if (cardsLeft != null)
            Container(
              child: Text("Cards left ${this.cardsLeft}"),
            )
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1)),
    );
  }
}
