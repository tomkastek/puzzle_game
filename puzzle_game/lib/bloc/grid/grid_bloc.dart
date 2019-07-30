import 'dart:async';

import 'package:puzzle_game/model/battle/board_point.dart';
import 'package:puzzle_game/bloc/grid/grid_event.dart';
import 'package:puzzle_game/bloc/grid/grid_state.dart';
import 'package:bloc/bloc.dart';
import 'package:puzzle_game/model/battle/board_grid.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  int height;
  int width;
  Timer _movementTimer;
  Timer _resolvingTimer;

  static const int hideResolvedMilliseconds = 500;

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
    } else if (event is ResolvedGrid) {
      yield* _mapResolveToState(event);
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

  Stream<GridState> _mapDragEndToState(GridDragEnd end) async* {
    _movementTimer?.cancel();
    if (currentState is Dragging) {
      if ((currentState as Dragging).movingStarted) {
        currentState.grid.resolve(pointFromIndex(0));
        yield Resolving(currentState.grid, 0);
        _resolvingTimer = Timer(Duration(milliseconds: 200), () {
          dispatch(ResolvedGrid(0));
        });
        return;
      }
    }
    // Default is that nothing moved
    yield Ready(currentState.grid);
  }

  Stream<GridState> _mapResolveToState(ResolvedGrid event) async* {
    var indexToCheck = event.checkedIndex + 1;
    if (indexToCheck >= width * height) {
      yield Ready(currentState.grid);
      return;
    }
    var solvable = currentState.grid.resolve(pointFromIndex(indexToCheck));
    yield Resolving(currentState.grid, indexToCheck);
    if (solvable) {
      _resolvingTimer = Timer(Duration(milliseconds: hideResolvedMilliseconds), () {
        dispatch(ResolvedGrid(indexToCheck));
      });
    } else {
      dispatch(ResolvedGrid(indexToCheck));
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

  BoardPoint pointFromIndex(int index) {
    return BoardPoint(xPos(index), yPos(index));
  }

  int xPos(int fromIndex) {
    return (fromIndex / numberOfColumns()).floor();
  }

  int yPos(int fromIndex) {
    return (fromIndex % numberOfColumns());
  }
}
