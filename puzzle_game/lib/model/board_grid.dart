import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:puzzle_game/battle/CircleItem.dart';

class BoardGrid extends Equatable {
  final int height;
  final int width;
  List<List<CircleItem>> grid;

  BoardGrid.random(this.height, this.width, {List props = const []}) : super([height, width]..addAll(props)) {
    this.grid = _randomGrid();
    super.props.add(grid);
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

  // TODO: after horizontal, check vertical and so on for complete board
  // TODO: Reduce code duplication
  void resolve(Point<int> from) {
    var item = grid[from.x][from.y];
    if (item.variant == CircleVariant.solved) {
      return;
    }
    
    var horizontalSolvable = _isHorizontalResolvable(from, item);
    if (horizontalSolvable.length > 1) {
      horizontalSolvable.add(from);
      for (var item in horizontalSolvable) {
        grid[item.x][item.y] = CircleItem(CircleVariant.solved);
      }
    }

    var verticalSolvable = _isVerticalResolvable(from, item);
    if (verticalSolvable.length > 1) {
      verticalSolvable.add(from);
      for (var item in verticalSolvable) {
        grid[item.x][item.y] = CircleItem(CircleVariant.solved);
      }
    }
  }

  List<Point<int>> _isHorizontalResolvable(Point<int> from, CircleItem item) {
    var sameOnLeft = _sameItemsOnLeft(from, item, []);
    var sameOnRight = _sameItemsOnRight(from, item, []);
    return sameOnRight..addAll(sameOnLeft);
  }

  List<Point<int>> _isVerticalResolvable(Point<int> from, CircleItem item) {
    var sameOnTop = _sameItemsOnTop(from, item, []);
    var sameOnBottom = _sameItemsOnBottom(from, item, []);
    return sameOnTop..addAll(sameOnBottom);
  }

  List<Point<int>> _sameItemsOnLeft(
      Point<int> from, CircleItem item, List<Point<int>> items) {
    var newColumn = from.y - 1;
    if (newColumn >= 0) {
      var compareItem = grid[from.x][newColumn];
      if (item == compareItem) {
        return _sameItemsOnLeft(
            Point(from.x, newColumn), item, items..add(Point(from.x, newColumn)));
      }
    }
    return items;
  }

  List<Point<int>> _sameItemsOnRight(
      Point<int> from, CircleItem item, List<Point<int>> items) {
    var newColumn = from.y + 1;
    if (newColumn < grid[0].length) {
      var compareItem = grid[from.x][newColumn];
      if (item == compareItem) {
        return _sameItemsOnRight(
            Point(from.x, newColumn), item, items..add(Point(from.x, newColumn)));
      }
    }
    return items;
  }

  List<Point<int>> _sameItemsOnTop(
      Point<int> from, CircleItem item, List<Point<int>> items) {
    var newRow = from.x - 1;
    if (newRow >= 0) {
      var compareItem = grid[newRow][from.y];
      if (item == compareItem) {
        return _sameItemsOnTop(
            Point(newRow, from.y), item, items..add(Point(newRow, from.y)));
      }
    }
    return items;
  }

  List<Point<int>> _sameItemsOnBottom(
      Point<int> from, CircleItem item, List<Point<int>> items) {
    var newRow = from.x + 1;
    if (newRow < grid.length) {
      var compareItem = grid[newRow][from.y];
      if (item == compareItem) {
        return _sameItemsOnBottom(
            Point(newRow, from.y), item, items..add(Point(newRow, from.y)));
      }
    }
    return items;
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
