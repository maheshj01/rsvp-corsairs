import 'package:flutter/material.dart';

class LeaderBoard extends StatefulWidget {
  static String route = '/';
  const LeaderBoard({
    Key? key,
  }) : super(key: key);

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.red,
      ),
    );
  }
}
