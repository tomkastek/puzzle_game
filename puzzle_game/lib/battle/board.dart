import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/board_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/bloc/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid_state.dart';

/// Class to define one puzzle board of the game.
/// Defines the grid (Content of field, number of fileds, size of fields)
class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GridBloc gridBloc = BlocProvider.of<GridBloc>(context);
    var boardWidth = MediaQuery.of(context).size.width;
    return Column(children: <Widget>[
      BlocBuilder(
        bloc: gridBloc,
        builder: (context, GridState state) {
          return Container(
            height: state.numberOfRows() / state.numberOfColumns() * boardWidth,
            width: boardWidth,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(), // disable scrolling
              crossAxisCount: state.numberOfColumns(),
              childAspectRatio: 1,
              children: List.generate(state.numberOfItems(), (index) {
                return BoardField(index: index);
              }),
            ),
          );
        },
      ),
    ]);
  }
}
