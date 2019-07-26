import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/BoardTarget.dart';
import 'package:puzzle_game/battle/board_item.dart';
import 'package:puzzle_game/bloc/grid_state.dart';

/// The item that shall be shown on a field while the user is moving a item on
/// the board.
class BoardItemWhileDragging extends StatelessWidget {
  const BoardItemWhileDragging({
    Key key,
    @required this.x,
    @required this.y,
    @required this.state,
    @required this.index,
  }) : super(key: key);

  final int x;
  final int y;
  final int index;
  final Dragging state;

  @override
  Widget build(BuildContext context) {
    return state.draggedIndex != index
        ? BoardTarget(x: x, y: y, state: state, index: index)
        : BoardItem(
            item: state.grid[x][y],
            alpha: 50,
          );
  }
}
