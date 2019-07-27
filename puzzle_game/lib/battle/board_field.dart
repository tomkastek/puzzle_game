import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/battle/BoardDraggable.dart';
import 'package:puzzle_game/battle/BoardItemWhileDragging.dart';
import 'package:puzzle_game/bloc/grid/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid/grid_state.dart';

/// This class sets up one field of the board of the game
/// gridState and index are used to get the x/y coordinates of the field to set up
/// The background of the field and a border around the field will be set
/// The item of the gridState at x/y a will be displayed on the field.
class BoardField extends StatelessWidget {
  BoardField(
      {Key key, @required this.index, @required this.x, @required this.y})
      : super(key: key);

  final int index;
  final int x;
  final int y;

  @override
  Widget build(BuildContext context) {
    var dark = x % 2 == 0 ? index % 2 == 0 : index % 2 == 1;
    var backgroundColor = dark ? Colors.brown[500] : Colors.brown[700];

    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          color: backgroundColor),
      child: LayoutBuilder(builder: (context, constraints) {
        return BlocBuilder<GridBloc, GridState>(
          builder: (context, state) {
            if (state is Dragging) {
              return BoardItemWhileDragging(
                  index: index, state: state, y: y, x: x);
            }
            var feedbackHeight = constraints.biggest.height * 1.1;
            var feedbackWidth = constraints.biggest.width * 1.1;
            return BoardDraggable(
                x: x,
                y: y,
                state: state,
                index: index,
                feedbackHeight: feedbackHeight,
                feedbackWidth: feedbackWidth);
          },
        );
      }),
    );
  }
}
