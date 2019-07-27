import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_game/model/board_grid.dart';

@immutable
abstract class GridState extends Equatable {
  final BoardGrid grid;

  GridState(this.grid, {List props = const []}) : super([grid]..addAll(props));
}

class Ready extends GridState {
  Ready(BoardGrid grid) : super(grid);
}

class Dragging extends GridState {
  final int draggedIndex;
  final bool movingStarted;

  Dragging(BoardGrid grid,
      {@required this.draggedIndex, @required this.movingStarted})
      : super(grid, props: [draggedIndex, movingStarted]);
}

class Resolving extends GridState {
  final int lastCheckedIndex;

  Resolving(BoardGrid grid, this.lastCheckedIndex)
      : super(grid, props: [lastCheckedIndex]);
}
