import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/battle_page.dart';

// TODO: Add a real home page there you can choose a level etc.
class BoardPuzzleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Board Puzzle App',
      theme: ThemeData(),
      home: BattlePage(),
    );
  }
}