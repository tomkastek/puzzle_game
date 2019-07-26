import 'dart:async';
import 'dart:math';

import 'package:puzzle_game/battle/CircleItem.dart';
import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';
import 'package:bloc/bloc.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  int height;
  int width;
  Timer _movementTimer;
  Timer _resolvingTimer;

  GridBloc({this.height = 5, this.width = 6});

  @override
  GridState get initialState => Ready(randomGrid());

  @override
  Stream<GridState> mapEventToState(GridEvent event) async* {
    if (event is GridDragBegan) {
      yield* _mapDragBeganToState(event);
    } else if (event is GridDragEnd) {
      yield* _mapDragEndToState(event);
    } else if (event is GridDragHovered) {
      yield* _mapDragHoveredToState(event);
    } else {
      yield currentState;
    }
  }

  @override
  void dispose() {
    _movementTimer?.cancel();
    _resolvingTimer?.cancel();
    super.dispose();
  }

  Stream<GridState> _mapDragBeganToState(GridDragBegan began) async* {
    yield Dragging(currentState.grid,
        draggedIndex: began.index, movingStarted: false);
  }

  Stream<GridState> _mapDragEndToState(GridDragEnd end) async* {
    _movementTimer?.cancel();
    if (currentState is Dragging) {
      if ((currentState as Dragging).movingStarted) {
        yield Resolving(currentState.grid, 0);
        _resolvingTimer = Timer(Duration(milliseconds: 200), () {
          ResolvedGrid(0);
        });
        return;
      }
    }
    // Default is that nothing moved
    yield Ready(currentState.grid);
  }

  Stream<GridState> _mapDragHoveredToState(GridDragHovered event) async* {
    if (currentState is Dragging) {
      var gridCopy =
          _changeCircles((currentState as Dragging).draggedIndex, event.to);
      yield Dragging(gridCopy, draggedIndex: event.to, movingStarted: true);
    }
    if (_movementTimer == null || !_movementTimer.isActive) {
      _movementTimer = Timer(Duration(seconds: 6), () {
        dispatch(GridDragEnd());
      });
    }
  }

  List<List<CircleItem>> randomGrid() {
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

  List<List<CircleItem>> _changeCircles(int first, int second) {
    var x1 = xPos(first);
    var y1 = yPos(first);
    var x2 = xPos(second);
    var y2 = yPos(second);
    var gridCopy = currentState.grid;
    var circleVariant = gridCopy[x1][y1];
    if (_areNeighbours(x1, y1, x2, y2)) {
      gridCopy[x1][y1] = gridCopy[x2][y2];
      gridCopy[x2][y2] = circleVariant;
    } else if (_areSecondNeighbours(x1, y1, x2, y2)) {
      var xBetween = (x1 + x2) ~/ 2;
      var yBetween = (y1 + y2) ~/ 2;
      gridCopy[x1][y1] = gridCopy[xBetween][yBetween];
      gridCopy[xBetween][yBetween] = gridCopy[x2][y2];
      gridCopy[x2][y2] = circleVariant;
    } else {
      // No support for longer distances
      // TODO: "return" false to keep the dragged index the same
      gridCopy[x1][y1] = gridCopy[x2][y2];
      gridCopy[x2][y2] = circleVariant;
    }
    return gridCopy;
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

  // MARK: Starting helper functions here
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
