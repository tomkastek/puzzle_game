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

  /// Checks the neighbours of the given point. If the neighbours are the same
  /// elements as the point they will be changed with solved items.
  bool resolve(BoardPoint from) {
    var item = grid[from.x][from.y];
    if (item.variant == CircleVariant.solved) {
      return false;
    }

    var horizontalSolvable = _isHorizontalResolvable(from, item, [from]);
    for (var item in horizontalSolvable) {
      grid[item.x][item.y] = CircleItem(CircleVariant.solved);
    }

    var verticalSolvable = _isVerticalResolvable(from, item, [from]);
    for (var item in verticalSolvable) {
      grid[item.x][item.y] = CircleItem(CircleVariant.solved);
    }

    if (verticalSolvable.length > 1 || horizontalSolvable.length > 1) {
      grid[from.x][from.y] = CircleItem(CircleVariant.solved);
      return true;
    }

    return false;
  }

  /// Checks for horizontal items. If they are the same as the given item and
  /// more than two, the same items will be returned as list.
  /// Also it will recursive look for all same points if in the vertical
  /// direction they have also the same neighbours
  List<BoardPoint> _isHorizontalResolvable(
      BoardPoint from, CircleItem item, List<BoardPoint> alreadySolved) {
    List<BoardPoint> horizantalSames = _sameOnHorizontal(from, item);
    return _resolveFoundInOtherDirection(
        Axis.vertical, horizantalSames, alreadySolved);
  }

  /// Checks for vertical items. If they are the same as the given item and
  /// more than two, the same items will be returned as list.
  /// Also it will recursive look for all same points if in the horizontal
  /// direction they have also the same neighbours
  List<BoardPoint> _isVerticalResolvable(
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
          List<BoardPoint> resolveables = resolveInDirection(
              next, solvedPoint, solvedItem, alreadySolved, itemsToCheck);
          if (resolveables.length > 1) {
            newOnes..addAll(resolveables);
          } else {
            var sameDirectionSolvedNeighbours = solveNeighbourInSameDirection(
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

  List<BoardPoint> resolveInDirection(
      Axis next,
      BoardPoint solvedPoint,
      CircleItem solvedItem,
      List<BoardPoint> alreadySolved,
      List<BoardPoint> itemsToCheck) {
    var resolveables = next == Axis.horizontal
        ? _isHorizontalResolvable(solvedPoint, solvedItem,
            []..addAll(alreadySolved)..addAll(itemsToCheck))
        : _isVerticalResolvable(solvedPoint, solvedItem,
            []..addAll(alreadySolved)..addAll(itemsToCheck));
    return resolveables;
  }

  /// If no cross = check if same single neighbour is resolvable in
  /// same Axis. Example:
  /// OXXX
  /// XXXO
  List<BoardPoint> solveNeighbourInSameDirection(Axis next, BoardPoint from,
      CircleItem item, List<BoardPoint> alreadySolved) {
    var sameNeighbour = next == Axis.horizontal
        ? _sameOnHorizontal(from, item)
        : _sameOnVertical(from, item);

    if (sameNeighbour.length == 1) {
      var toCheck = sameNeighbour.first;
      var axisResolveables = next == Axis.horizontal
          ? _isVerticalResolvable(toCheck, item, alreadySolved)
          : _isHorizontalResolvable(toCheck, item, alreadySolved);
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
