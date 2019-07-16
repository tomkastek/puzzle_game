import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/board.dart';

class BattlePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: Container()),
          SafeArea(child: Board()),
        ],
      ),
    );
  }
}
