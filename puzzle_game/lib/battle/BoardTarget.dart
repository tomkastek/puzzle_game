import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/battle/board_item.dart';
import 'package:puzzle_game/bloc/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';

/// This widget is used on the board for 'Dragging' state.
/// If a item in the board is a target the dragged item can be hovered over it
/// and the dragged item can be placed here.
class BoardTarget extends StatelessWidget {
  const BoardTarget({
    Key key,
    @required this.x,
    @required this.y,
    @required this.state,
    @required this.index,
  }) : super(key: key);

  final int x;
  final int y;
  final GridState state;
  final int index;

  @override
  Widget build(BuildContext context) {
    final gridBloc = BlocProvider.of<GridBloc>(context);
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        return BoardItem(
          itemIdentifier: state.grid[x][y],
        );
      },
      onWillAccept: (int) {
        print(index);
        gridBloc.dispatch(GridDragHovered(index));
        return true;
      },
      onAccept: (int data) {
        gridBloc.dispatch(GridDragEnd());
      },
    );
  }
}
