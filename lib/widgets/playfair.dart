import 'package:bluff/widgets/button.dart';
import 'package:flutter/material.dart';

class PlayFair extends StatefulWidget {
  final List cards;

  const PlayFair({@required this.cards});

  @override
  _PlayFairState createState() => _PlayFairState();
}

class _PlayFairState extends State<PlayFair> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width.roundToDouble();
    final screenHeight =
        MediaQuery.of(context).size.height.roundToDouble() - 20.0;
    screenWidth = screenWidth < 1000 ? screenWidth : 1000;

    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: allCardsDisp(screenHeight, screenWidth));
  }

  List<Widget> allCardsDisp(double screenHeight, double screenWidth) {
    var totalRws = <Widget>[];
    var rw = <Widget>[];
    for (var i = 0; i < widget.cards.length; i++) {
      rw.add(CustomButtom(
          height: screenHeight / 20,
          width: screenWidth / 6,
          onPressed: () {},
          cardNumber: widget.cards[i]));
      if ((i + 1) % 5 == 0) {
        totalRws.add(Row(
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

  List<Widget> singleRow(
      List<int> li, double screenHeight, double screenWidth) {
    var rw = <Widget>[];
    for (var i = 0; i < li.length; i++) {
      rw.add(CustomButtom(
        height: screenHeight / 20,
        width: screenWidth / 6,
        onPressed: () {},
        cardNumber: li[i],
      ));
    }
    return rw;
  }
}
