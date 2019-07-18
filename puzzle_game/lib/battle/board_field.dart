import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/battle/board_item.dart';
import 'package:puzzle_game/bloc/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid_state.dart';

/// This class sets up one field of the board of the game
/// gridState and index are used to get the x/y coordinates of the field to set up
/// The background of the field and a border around the field will be set
/// The item of the gridState at x/y a will be displayed on the field.
class BoardField extends StatelessWidget {
  BoardField({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    final gridBloc = BlocProvider.of<GridBloc>(context);

    return BlocBuilder(bloc: gridBloc, builder: (context, GridState state) {
      int x = state.xPos(index);
      int y = state.yPos(index);
      var dark = x % 2 == 0 ? index % 2 == 0 : index % 2 == 1;
      return Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 0.5),
            color: dark ? Colors.brown[500] : Colors.brown[700]),
        child: Center(
          child: BoardItem(
            itemIdentifier: state.gridState[x][y],
          ),
        ),
      );
    });
  }
}
