import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GridState extends Equatable {
  final List<List<String>> grid;
  final int width;
  final int height;

  GridState(this.grid,
      {@required this.width, @required this.height, List props = const []})
      : assert(width != null),
        assert(height != null),
        super([grid, width, height]..addAll(props));

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
  Ready(List<List<String>> grid, {@required int width, @required int height})
      : super(grid, width: width, height: height);
}

class Dragging extends GridState {
  Dragging(List<List<String>> grid,
      {@required int width, @required int height})
      : super(grid, width: width, height: height);
}
