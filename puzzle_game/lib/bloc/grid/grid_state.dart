import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_game/model/battle/board_grid.dart';

@immutable
abstract class GridState extends Equatable {
  final BoardGrid grid;

  GridState(this.grid, {List props = const []}) : super([grid,...props]);
}

class Ready extends GridState {
  Ready(BoardGrid grid) : super(grid);

  @override
  String toString() => 'Ready';
}

class Dragging extends GridState {
  final int draggedIndex;
  final bool movingStarted;

  Dragging(BoardGrid grid,
      {@required this.draggedIndex, @required this.movingStarted})
      : super(grid, props: [draggedIndex, movingStarted]);

  @override
  String toString() => 'Dragging { draggedIndex: $draggedIndex, movingStarted: $movingStarted }';
}

class Resolving extends GridState {
  final int lastChecked;

  Resolving(BoardGrid grid, this.lastChecked)
      : assert(lastChecked != null),
        super(grid, props: [grid, lastChecked]);

  @override
  String toString() => 'Resolving { lastChecked: $lastChecked }';
}

class WaitForFill extends GridState {
  WaitForFill(BoardGrid grid) : super(grid);

  @override
  String toString() => 'WaitForFill';
}
