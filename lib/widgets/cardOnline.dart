import 'package:flutter/material.dart';

class CardOnline extends StatelessWidget {
  final String name;
  final String cardsLeft;
  final String currentTurn;

  CardOnline({@required this.name, this.cardsLeft, this.currentTurn});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: ListTile(
          leading: Icon(
            Icons.circle,
            color: Colors.green,
          ),
          title: (Text(
            this.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )),
          subtitle: this.cardsLeft == null
              ? Text("")
              : Text("Cards left ${this.cardsLeft}"),
        ),
        color: this.currentTurn == this.name
            ? Colors.greenAccent[100]
            : Colors.blue[100],
      ),
    );
  }
}
