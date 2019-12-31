import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/model/battle/circle_item.dart';
import 'package:puzzle_game/battle/board_item.dart';
import 'package:puzzle_game/bloc/grid/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid/grid_event.dart';
import 'package:puzzle_game/bloc/grid/grid_state.dart';

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
    final item = state.grid.itemFor(x, y);

    return Draggable<int>(
        feedback: BoardDraggableFeedback(
          height: feedbackHeight,
          width: feedbackWidth,
          item: item,
          superContext: context,
        ),
        dragAnchor: DragAnchor.pointer,
        data: index,
        onDragStarted: () {
          gridBloc.dispatch(GridDragBegan(index));
        },
        onDraggableCanceled: (velocity, offset) {
          gridBloc.dispatch(GridDragEnd());
        },
        child: BoardItem(
          item: item,
        ));
  }
}

class BoardDraggableFeedback extends StatelessWidget {
  final double height;
  final double width;
  final CircleItem item;
  final BuildContext superContext; // Context does not contain GridBloc

  const BoardDraggableFeedback(
      {Key key, this.height, this.width, this.item, this.superContext})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gridBloc = BlocProvider.of<GridBloc>(superContext);

    return BlocBuilder(
      bloc: gridBloc, // Can't read bloc from context
      builder: (context, GridState state) {
        // TODO: Create a global touch point state to show transform feedback into board
        return (state is Dragging)
            ? Container(
                height: height,
                width: width,
                transform:
                    Matrix4.translationValues(-height / 2, -width / 1.5, 0),
                child: BoardItem(
                  item: item,
                ),
              )
            : Container();
      },
    );
  }
}
