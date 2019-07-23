import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/battle/board_item.dart';
import 'package:puzzle_game/bloc/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';


/// This widget is a object on the board in 'Ready' state.
/// Every field represented by this widget is a possible start point for user
/// interaction. It can be dragged over the board.
class BoardDraggable extends StatelessWidget {
  const BoardDraggable({
    Key key,
    @required this.x,
    @required this.y,
    @required this.state,
    @required this.index,
    @required this.feedbackHeight,
    @required this.feedbackWidth,
  }) : super(key: key);

  final int x;
  final int y;
  final int index;
  final double feedbackHeight; // Slightly bigger than field
  final double feedbackWidth;
  final GridState state;

  @override
  Widget build(BuildContext context) {
    final gridBloc = BlocProvider.of<GridBloc>(context);
    return Draggable<int>(
      child: BoardItem(
        itemIdentifier: state.grid[x][y],
      ),
      feedback: Container(
        height: feedbackHeight,
        width: feedbackWidth,
        transform: Matrix4.translationValues(
            -feedbackHeight / 2,
            -feedbackWidth / 1.5,
            0),
        child: BoardItem(
          itemIdentifier: state.grid[x][y],
        ),
      ),
      childWhenDragging: BoardItem(
        itemIdentifier: state.grid[x][y],
        alpha: 50,
      ),
      dragAnchor: DragAnchor.pointer,
      maxSimultaneousDrags: 1,
      data: index,
      onDragStarted: () {
        gridBloc.dispatch(GridDragBegan(index));
      },
      onDraggableCanceled: (velocity, offset) {
        gridBloc.dispatch(GridDragCancelled());
      },
    );
  }
}