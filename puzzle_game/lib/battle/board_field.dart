import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/board_item.dart';

/// This class sets up one field of the board of the game
/// gridState and index are used to get the x/y coordinates of the field to set up
/// The background of the field and a border around the field will be set
/// The item of the gridState at x/y a will be displayed on the field.
class BoardField extends StatelessWidget {
  BoardField({Key key, @required this.gridState, this.index}) : super(key: key);

  final List<List<String>> gridState;
  final int index;

  @override
  Widget build(BuildContext context) {
    int x, y = 0;
    x = (index / gridState.first.length).floor();
    y = (index % gridState.first.length);
    var dark = x % 2 == 0 ? index % 2 == 0 : index % 2 == 1;

    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
              color: dark ? Colors.brown[500] : Colors.brown[700]),
          child: Center(
            child: BoardItem(
              itemIdentifier: gridState[x][y],
            ),
          ),
        ),
      ),
    );
  }

  void _gridItemTapped(int x, int y) {}
}