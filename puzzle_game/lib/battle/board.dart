import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/board_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puzzle_game/bloc/grid_bloc.dart';

/// Class to define one puzzle board of the game.
/// Defines the grid (Content of field, number of fileds, size of fields)
class Board extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GridBloc gridBloc = BlocProvider.of<GridBloc>(context);

    var boardWidth = MediaQuery.of(context).size.width;
    var boardHeight =
        gridBloc.numberOfRows() / gridBloc.numberOfColumns() * boardWidth;

    return Column(children: <Widget>[
      Container(
        height: boardHeight,
        width: boardWidth,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(), // disable scrolling
          crossAxisCount: gridBloc.numberOfColumns(),
          children: boardGridFields(gridBloc),
        ),
      ),
    ]);
  }

  List<Widget> boardGridFields(GridBloc gridBloc) {
    return List.generate(gridBloc.numberOfItems(), (index) {
      var x = gridBloc.xPos(index);
      var y = gridBloc.yPos(index);

      return BoardField(index: index, x: x, y: y);
    });
  }
}
