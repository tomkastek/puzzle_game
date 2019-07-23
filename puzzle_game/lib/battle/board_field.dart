import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/battle/BoardDraggable.dart';
import 'package:puzzle_game/battle/BoardItemWhileDragging.dart';
import 'package:puzzle_game/bloc/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid_state.dart';

/// This class sets up one field of the board of the game
/// gridState and index are used to get the x/y coordinates of the field to set up
/// The background of the field and a border around the field will be set
/// The item of the gridState at x/y a will be displayed on the field.
// TODO: replace hardcoded values with propertiers
class BoardField extends StatelessWidget {
  BoardField(
      {Key key, @required this.index, @required this.x, @required this.y})
      : super(key: key);

  final int index;
  final int x;
  final int y;

  @override
  Widget build(BuildContext context) {
    final gridBloc = BlocProvider.of<GridBloc>(context);
    var dark = x % 2 == 0 ? index % 2 == 0 : index % 2 == 1;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          color: dark ? Colors.brown[500] : Colors.brown[700]),
      child: LayoutBuilder(builder: (context, constraints) {
        return BlocBuilder(
          bloc: gridBloc,
          builder: (context, GridState state) {
            if (state is Dragging) {
              BoardItemWhileDragging(index: index, state: state, y: y, x: x);
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

