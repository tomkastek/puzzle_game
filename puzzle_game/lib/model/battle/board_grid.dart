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
        // TODO: savety for enum sorting (I miss swift enum functionality...)
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

  /// Checks the neighbours of the given point. If the neighbours are the same
  /// elements as the point they will be changed with solved items.
  bool resolve(BoardPoint from) {
    var item = grid[from.x][from.y];
    if (item.variant == CircleVariant.solved) {
      return false;
    }

    var wasSolveable = _solveIfPossible(from, item);
    if (wasSolveable) {
      grid[from.x][from.y] = CircleItem(CircleVariant.solved);
    }

    return wasSolveable;
  }

  /// This function is used after a board is resolved.
  /// The Items on top need to fall down
  /// @return true if a correction happened
  bool correctItemPlacements() {
    var correctionHappened = false;
    // bottom row is not needed to check
    for (var x = height - 2; x >= 0; x--) {
      for (var y = width -1; y >= 0; y--) {
        if (grid[x][y].variant != CircleVariant.solved) {
          var belowFree = _lastBelowSolvedPoint(BoardPoint(x, y));
          if (belowFree.x != x) {
            correctionHappened = true;
            grid[belowFree.x][y] = grid[x][y];
            grid[x][y] = CircleItem(CircleVariant.solved);
          }
        } else {
          // Just to know that there even was a solved griditem
          correctionHappened = true;
        }
      }
    }
    return correctionHappened;
  }

  /// fills al solved items with a new item
  /// @return true if a field was refilled
  bool refill() {
    var refilled = false;
    var i = Random();
    for (var x = height - 1; x >= 0; x--) {
      for (var y = width -1; y >= 0; y--) {
        if (grid[x][y].variant == CircleVariant.solved) {
          refilled = true;
          // TODO: see randomGrid()
          var randomNumber = i.nextInt(5);
          grid[x][y] = CircleItem(CircleVariant.values[randomNumber]);
        }
      }
    }
    return refilled;
  }

  BoardPoint _lastBelowSolvedPoint(BoardPoint from) {
    if (from.x < height - 1) {
      var nextPoint = grid[from.x + 1][from.y];
      if (nextPoint.variant == CircleVariant.solved) {
        return _lastBelowSolvedPoint(BoardPoint(from.x + 1, from.y));
      }
    }
    return from;
  }

  /// Solves the puzzle from a given point
  /// If a row/column was found it returns true, false otherwise
  bool _solveIfPossible(BoardPoint from, CircleItem item) {
    var horizontalSolvable = _solveHorizontal(from, item, [from]);
    _changeToSolvedItems(horizontalSolvable);

    var verticalSolvable = _solveVertical(from, item, [from]);
    _changeToSolvedItems(verticalSolvable);

    if (verticalSolvable.length > 1 || horizontalSolvable.length > 1) {
      return true;
    }
    return false;
  }

  void _changeToSolvedItems(List<BoardPoint> horizontalSolvable) {
    for (var item in horizontalSolvable) {
      grid[item.x][item.y] = CircleItem(CircleVariant.solved);
    }
  }

  /// Checks for horizontal items. If they are the same as the given item and
  /// more than two, the same items will be returned as list.
  /// Also it will recursive look for all same points if in the vertical
  /// direction they have also the same neighbours
  List<BoardPoint> _solveHorizontal(
      BoardPoint from, CircleItem item, List<BoardPoint> alreadySolved) {
    List<BoardPoint> horizantalSames = _sameOnHorizontal(from, item);
    return _resolveFoundInOtherDirection(
        Axis.vertical, horizantalSames, alreadySolved);
  }

  /// Checks for vertical items. If they are the same as the given item and
  /// more than two, the same items will be returned as list.
  /// Also it will recursive look for all same points if in the horizontal
  /// direction they have also the same neighbours
  List<BoardPoint> _solveVertical(
      BoardPoint from, CircleItem item, List<BoardPoint> alreadySolved) {
    List<BoardPoint> verticalSames = _sameOnVertical(from, item);
    return _resolveFoundInOtherDirection(
        Axis.horizontal, verticalSames, alreadySolved);
  }

  /// For all given points this method will check the next direction if it will
  /// find a row of three or longer as well.
  List<BoardPoint> _resolveFoundInOtherDirection(Axis next,
      List<BoardPoint> itemsToCheck, List<BoardPoint> alreadySolved) {
    if (itemsToCheck.length > 1) {
      List<BoardPoint> newOnes = [];
      for (var solvedPoint in itemsToCheck) {
        if (!alreadySolved.contains(solvedPoint)) {
          var solvedItem = grid[solvedPoint.x][solvedPoint.y];

          // Check for each new point the other axis to find crosses for example
          List<BoardPoint> resolveables = _resolveInDirection(
              next, solvedPoint, solvedItem, alreadySolved, itemsToCheck);
          if (resolveables.length > 1) {
            newOnes..addAll(resolveables);
          } else {
            var sameDirectionSolvedNeighbours = _solveNeighbourInSameDirection(
                next,
                solvedPoint,
                solvedItem,
                []..addAll(alreadySolved)..addAll(itemsToCheck));
            newOnes..addAll(sameDirectionSolvedNeighbours);
          }
        }
      }
      itemsToCheck..addAll(newOnes);
      return itemsToCheck;
    }
    return [];
  }

  List<BoardPoint> _resolveInDirection(
      Axis next,
      BoardPoint solvedPoint,
      CircleItem solvedItem,
      List<BoardPoint> alreadySolved,
      List<BoardPoint> itemsToCheck) {
    var resolveables = next == Axis.horizontal
        ? _solveHorizontal(solvedPoint, solvedItem,
            []..addAll(alreadySolved)..addAll(itemsToCheck))
        : _solveVertical(solvedPoint, solvedItem,
            []..addAll(alreadySolved)..addAll(itemsToCheck));
    return resolveables;
  }

  /// If no cross = check if same single neighbour is resolvable in
  /// same Axis. Example:
  /// OXXX
  /// XXXO
  List<BoardPoint> _solveNeighbourInSameDirection(Axis next, BoardPoint from,
      CircleItem item, List<BoardPoint> alreadySolved) {
    var sameNeighbour = next == Axis.horizontal
        ? _sameOnHorizontal(from, item)
        : _sameOnVertical(from, item);

    if (sameNeighbour.length == 1) {
      var toCheck = sameNeighbour.first;
      var axisResolveables = next == Axis.horizontal
          ? _solveVertical(toCheck, item, alreadySolved)
          : _solveHorizontal(toCheck, item, alreadySolved);
      if (axisResolveables.length > 1) {
        return axisResolveables..add(toCheck);
      }
    }
    return [];
  }

  List<BoardPoint> _sameOnHorizontal(BoardPoint from, CircleItem item) {
    var sameOnLeft = _sameItemsOn(AxisDirection.left, from, item, []);
    var sameOnRight = _sameItemsOn(AxisDirection.right, from, item, []);
    return sameOnRight..addAll(sameOnLeft);
  }

  List<BoardPoint> _sameOnVertical(BoardPoint from, CircleItem item) {
    var sameOnTop = _sameItemsOn(AxisDirection.up, from, item, []);
    var sameOnBottom = _sameItemsOn(AxisDirection.down, from, item, []);
    var all = sameOnTop..addAll(sameOnBottom);
    return all;
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
