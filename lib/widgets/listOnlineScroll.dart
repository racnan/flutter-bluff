import 'package:flutter/material.dart';

class OnlineScroller extends StatelessWidget {
  final List<Widget> widgetList;

  OnlineScroller({@required this.widgetList});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [...widgetList],
        ),
      ),
    );
  }
}
