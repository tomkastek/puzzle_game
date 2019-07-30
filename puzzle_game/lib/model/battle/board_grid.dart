import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:puzzle_game/model/battle/CircleItem.dart';
import 'package:puzzle_game/model/battle/board_point.dart';

class BoardGrid extends Equatable {
  final int height;
  final int width;
  List<List<CircleItem>> grid;

  BoardGrid.random(this.height, this.width, {List props = const []})
      : super([height, width]..addAll(props)) {
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

  void changeCircles(BoardPoint first, BoardPoint second) {
    var circleVariant = grid[first.x][first.y];
    if (first.isNeighbour(second)) {
      grid[first.x][first.y] = grid[second.x][second.y];
      grid[second.x][second.y] = circleVariant;
    } else if (first.isSecondNeighbour(second)) {
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
  bool resolve(BoardPoint from) {
    var wasSolvable = false;
    var item = grid[from.x][from.y];
    if (item.variant == CircleVariant.solved) {
      return wasSolvable;
    }

    var horizontalSolvable = _isHorizontalResolvable(from, item);
    if (horizontalSolvable.length > 1) {
      wasSolvable = true;
      horizontalSolvable.add(from);
      for (var item in horizontalSolvable) {
        grid[item.x][item.y] = CircleItem(CircleVariant.solved);
      }
    }

    var verticalSolvable = _isVerticalResolvable(from, item);
    if (verticalSolvable.length > 1) {
      wasSolvable = true;
      verticalSolvable.add(from);
      for (var item in verticalSolvable) {
        grid[item.x][item.y] = CircleItem(CircleVariant.solved);
      }
    }
    return wasSolvable;
  }

  List<BoardPoint> _isHorizontalResolvable(BoardPoint from, CircleItem item) {
    var sameOnLeft = _sameItemsOn(AxisDirection.left, from, item, []);
    var sameOnRight = _sameItemsOn(AxisDirection.right, from, item, []);
    return sameOnRight..addAll(sameOnLeft);
  }

  List<BoardPoint> _isVerticalResolvable(BoardPoint from, CircleItem item) {
    var sameOnTop = _sameItemsOn(AxisDirection.up, from, item, []);
    var sameOnBottom = _sameItemsOn(AxisDirection.down, from, item, []);
    return sameOnTop..addAll(sameOnBottom);
  }

  List<BoardPoint> _sameItemsOn(AxisDirection direction, BoardPoint from,
      CircleItem item, List<BoardPoint> items) {
    var nextPoint = from.nextPointFor(direction);
    if (nextPoint.x >= 0 &&
        nextPoint.x < grid.length &&
        nextPoint.y >= 0 &&
        nextPoint.y < grid[0].length) {
      var compareItem = grid[nextPoint.x][nextPoint.y];
      if (item == compareItem) {
        return _sameItemsOn(direction, nextPoint, item, items..add(nextPoint));
      }
    }
    return items;
  }
}
