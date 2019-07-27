import 'dart:async';
import 'dart:math';

import 'package:puzzle_game/battle/CircleItem.dart';
import 'package:puzzle_game/bloc/grid/grid_event.dart';
import 'package:puzzle_game/bloc/grid/grid_state.dart';
import 'package:bloc/bloc.dart';
import 'package:puzzle_game/model/board_grid.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  int height;
  int width;
  Timer _movementTimer;
  Timer _resolvingTimer;

  GridBloc({this.height = 5, this.width = 6});

  @override
  GridState get initialState => Ready(BoardGrid.random(height, width));

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
      currentState.grid.changeCircles(
          pointFromIndex((currentState as Dragging).draggedIndex),
          pointFromIndex(event.to));
      yield Dragging(currentState.grid,
          draggedIndex: event.to, movingStarted: true);
    }
    if (_movementTimer == null || !_movementTimer.isActive) {
      _movementTimer = Timer(Duration(seconds: 6), () {
        dispatch(GridDragEnd());
      });
    }
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

  Point<int> pointFromIndex(int index) {
    return Point(xPos(index), yPos(index));
  }

  int xPos(int fromIndex) {
    return (fromIndex / numberOfColumns()).floor();
  }

  int yPos(int fromIndex) {
    return (fromIndex % numberOfColumns());
  }
}
