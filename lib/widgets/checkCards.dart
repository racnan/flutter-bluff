import 'package:flutter/material.dart';

import '../models/cards.dart';

class CheckCards extends StatelessWidget {
  final int card;
  final int quantity;

  CheckCards({@required this.card, @required this.quantity});

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
              NumberCards[card],
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Container(
            child: Text(
              " x$quantity",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1)),
    );
  }
}
