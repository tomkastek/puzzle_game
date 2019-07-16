import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/board_field.dart';

/// Class to define one puzzle board of the game.
/// Defines the grid (Content of field, number of fileds, size of fields)
class Board extends StatelessWidget {
  // TODO: handle the state not here. Use inheritedwidget, provider or BLoC and a grid class.
  final List<List<String>> gridState = [
    ['R', 'B', 'G', 'Y', 'D', 'R'],
    ['R', 'Y', 'D', 'D', 'R', 'G'],
    ['B', 'G', 'B', 'Y', 'Y', 'B'],
    ['R', 'G', 'G', 'B', 'D', 'R'],
    ['D', 'B', 'R', 'D', 'R', 'G'],
  ];

  @override
  Widget build(BuildContext context) {
    var gridStateLength = gridState.length * gridState.first.length;
    return Column(children: <Widget>[
      Container(
        height: 5 / 6 * MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(), // disable scrolling
          crossAxisCount: 6,
          childAspectRatio: 1,
          children: List.generate(gridStateLength, (index) {
            return BoardField(
              gridState: gridState,
              index: index,
            );
          }),
        ),
      ),
    ]);
  }
}