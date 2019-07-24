import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GridState extends Equatable {
  final List<List<String>> grid;

  GridState(this.grid, {List props = const []}) : super([grid]..addAll(props));
}

class Ready extends GridState {
  Ready(List<List<String>> grid) : super(grid);
}

class Dragging extends GridState {
  final int draggedIndex;

  Dragging(List<List<String>> grid, {@required this.draggedIndex})
      : super(grid, props: [draggedIndex]);
}
