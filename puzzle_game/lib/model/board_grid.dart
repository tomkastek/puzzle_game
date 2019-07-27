import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:puzzle_game/battle/CircleItem.dart';

class BoardGrid extends Equatable {
  final int height;
  final int width;
  List<List<CircleItem>> grid;

  BoardGrid.random(this.height, this.width, {List props = const []}) {
    this.grid = _randomGrid();
  }

  List<List<CircleItem>> _randomGrid() {
    List<List<CircleItem>> grid = [];
    var i = Random();

    for (int h = 0; h < height; h++) {
      List<CircleItem> row = [];
      for (int w = 0; w < width; w++) {
        var randomNumber = i.nextInt(5);
        row.add(CircleItem(CircleVariant.values[randomNumber]));
      }
      grid.add(row);
    }
    return grid;
  }

  CircleItem itemFor(int x, int y) {
    return grid[x][y];
  }

  void changeCircles(Point<int> first, Point<int> second) {
    var circleVariant = grid[first.x][first.y];
    if (_areNeighbours(first.x, first.y, second.x, second.y)) {
      grid[first.x][first.y] = grid[second.x][second.y];
      grid[second.x][second.y] = circleVariant;
    } else if (_areSecondNeighbours(first.x, first.y, second.x, second.y)) {
      var xBetween = (first.x + second.x) ~/ 2;
      var yBetween = (first.y + second.y) ~/ 2;
      grid[first.x][first.y] = grid[xBetween][yBetween];
      grid[xBetween][yBetween] = grid[second.x][second.y];
      grid[second.x][second.y] = circleVariant;
    } else {
      // No support for longer distances
      // TODO: "return" false to keep the dragged index the same
      grid[first.x][first.y] = grid[second.x][second.y];
      grid[second.x][second.y] = circleVariant;
    }
  }

  bool _areNeighbours(int x1, int y1, int x2, int y2) {
    if ([-1, 0, 1].contains(x1 - x2) && [-1, 0, 1].contains(y1 - y2)) {
      return true;
    }
    return false;
  }

  bool _areSecondNeighbours(int x1, int y1, int x2, int y2) {
    if (([2, -2].contains(x1 - x2) && [-2, -1, 0, 1, 2].contains(y1 - y2)) ||
        ([-2, -1, 0, 1, 2].contains(x1 - x2) && [-2, 2].contains(y1 - y2))) {
      return true;
    }
    return false;
  }
}
