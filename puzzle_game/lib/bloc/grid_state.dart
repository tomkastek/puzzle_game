import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GridState extends Equatable {
  final List<List<String>> grid;
  final int width;
  final int height;
  final List<int> history;

  GridState(this.grid,
      {@required this.width, @required this.height, @required this.history , List props = const []})
      : assert(width != null),
        assert(height != null),
        assert(height != null),
        super([grid, width, height, history]..addAll(props));

  int numberOfRows() {
    return height;
  }

  int numberOfColumns() {
    return width;
  }

  int numberOfItems() {
    return numberOfRows() * numberOfColumns();
  }

  int xPos(int fromIndex) {
    return (fromIndex / numberOfColumns()).floor();
  }

  int yPos(int fromIndex) {
    return (fromIndex % numberOfColumns());
  }
}

class Ready extends GridState {
  Ready(List<List<String>> grid, {@required int width, @required int height, @required List<int> history})
      : super(grid, width: width, height: height, history: history);
}

class Dragging extends GridState {
  final int draggedIndex;

  Dragging(List<List<String>> grid,
      {@required int width, @required int height, @required this.draggedIndex, @required List<int> history})
      : super(grid, width: width, height: height, props: [draggedIndex], history: history);
}
