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
  void onEvent(GridEvent event) {
//    final eventDescription = event.toString();
//    print('Event: $eventDescription');
    super.onEvent(event);
  }

  @override
  void onTransition(Transition<GridEvent, GridState> transition) {
//    final currentStateDescription = transition.currentState.toString();
//    final nextStateDescription = transition.nextState.toString();
//    final eventDescription = transition.event.toString();
//    print('Event: $eventDescription changed state from $currentStateDescription to $nextStateDescription');
    super.onTransition(transition);
  }

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
    } else if (event is GridSolved) {
      yield* _mapGridSolvedToState(event);
    } else if (event is RefillGrid) {
      yield* _mapRefillGridToState(event);
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
      _movementTimer = Timer(const Duration(seconds: 6), () {
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
        _resolvingTimer = Timer(const Duration(milliseconds: hideResolvedMilliseconds), () {
          dispatch(ResolvedGrid(0));
        });
        return;
      }
    }
    // Default is that nothing moved
    yield Ready(currentState.grid);
  }

  Stream<GridState> _mapResolveToState(ResolvedGrid event) async* {
    final indexToCheck = event.checkedIndex + 1;
    if (indexToCheck >= width * height) {
      yield Resolving(currentState.grid, indexToCheck);
      dispatch(GridSolved());
      return;
    }
    final solvable = currentState.grid.resolve(pointFromIndex(indexToCheck));
    yield Resolving(currentState.grid, indexToCheck);
    if (solvable) {
      _resolvingTimer = Timer(const Duration(milliseconds: hideResolvedMilliseconds), () {
        dispatch(ResolvedGrid(indexToCheck));
      });
    } else {
      dispatch(ResolvedGrid(indexToCheck));
    }
  }

  Stream<GridState> _mapGridSolvedToState(GridSolved event) async* {
    final correctionHappened = currentState.grid.correctItemPlacements();
    if (correctionHappened) {
      var fakeIndex = 0; // delete if grid is compareable. Until then we need a new index
      if (currentState is Resolving) {
        fakeIndex = (currentState as Resolving).lastChecked + 1;
      }
      yield Resolving(currentState.grid, fakeIndex);
      _resolvingTimer = Timer(const Duration(milliseconds: hideResolvedMilliseconds), () {
        dispatch(RefillGrid());
      });
    } else {
      yield Ready(currentState.grid);
    }

  }

  Stream<GridState> _mapRefillGridToState(RefillGrid event) async* {
    final refilled = currentState.grid.refill();
    yield Resolving(currentState.grid, -1);
    if (refilled) {
      _resolvingTimer = Timer(const Duration(milliseconds: hideResolvedMilliseconds), () {
        dispatch(ResolvedGrid(0));
      });
    } else {
      dispatch(GridSolved());
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
    return fromIndex % numberOfColumns();
  }
}
