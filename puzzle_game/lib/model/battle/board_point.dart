import 'dart:math';

import 'package:flutter/material.dart';

// TODO: replace .toInt everywhere
class BoardPoint {
  final int x;
  final int y;

  BoardPoint(this.x, this.y);

  BoardPoint nextPointFor(AxisDirection direction) {
    var row = x;
    var column = y;
    switch (direction) {
      case AxisDirection.down:
        row++;
        break;
      case AxisDirection.up:
        row--;
        break;
      case AxisDirection.left:
        column--;
        break;
      case AxisDirection.right:
        column++;
    }
    return BoardPoint(row, column);
  }

  bool isNeighbour(BoardPoint neighbour) {
    if ([-1, 0, 1].contains(x - neighbour.x) &&
        [-1, 0, 1].contains(y - neighbour.y)) {
      return true;
    }
    return false;
  }

  bool isSecondNeighbour(BoardPoint neighbour) {
    if (([2, -2].contains(x - neighbour.x) &&
            [-2, -1, 0, 1, 2].contains(y - neighbour.y)) ||
        ([-2, -1, 0, 1, 2].contains(neighbour.x - x) &&
            [-2, 2].contains(y - neighbour.y))) {
      return true;
    }
    return false;
  }
}
