import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/CircleItem.dart';

@immutable
abstract class GridState extends Equatable {
  final List<List<CircleItem>> grid;

  GridState(this.grid, {List props = const []}) : super([grid]..addAll(props));
}

class Ready extends GridState {
  Ready(List<List<CircleItem>> grid) : super(grid);
}

class Dragging extends GridState {
  final int draggedIndex;
  final bool movingStarted;

  Dragging(List<List<CircleItem>> grid,
      {@required this.draggedIndex, @required this.movingStarted})
      : super(grid, props: [draggedIndex, movingStarted]);
}

class Resolving extends GridState {
  Resolving(List<List<CircleItem>> grid)
      : super(grid);
}
