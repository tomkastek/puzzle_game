import 'dart:math';

import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';
import 'package:bloc/bloc.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  final List<String> circleVariants = ['R', 'B', 'G', 'Y', 'D'];
  int height;
  int width;

  GridBloc({this.height = 5, this.width = 6});

  @override
  GridState get initialState => Ready(randomGrid());

  @override
  Stream<GridState> mapEventToState(GridEvent event) async* {
    if (event is GridDragBegan) {
      yield* _mapDragBeganToState(event);
    } else if (event is GridDragEnd) {
      yield* _mapDragEndToState(event);
    } else if (event is GridDragCancelled) {
      yield* _mapDragCancelledToState(event);
    } else if (event is GridDragHovered) {
      yield* _mapDragHoveredToState(event);
    } else {
      yield currentState;
    }
  }

  Stream<GridState> _mapDragBeganToState(GridDragBegan began) async* {
    yield Dragging(currentState.grid, draggedIndex: began.index);
  }

  Stream<GridState> _mapDragEndToState(GridDragEnd end) async* {
    if (end.initial == end.changeWith) {
      yield Ready(currentState.grid);
    } else {
      var gridCopy = changeCircles(end.initial, end.changeWith);
      yield Ready(gridCopy);
    }
  }

  Stream<GridState> _mapDragHoveredToState(GridDragHovered event) async* {
    var state = currentState;
    if (state is Dragging) {
      var gridCopy = changeCircles(state.draggedIndex, event.to);
      yield Dragging(gridCopy, draggedIndex: event.to);
    }
  }

  Stream<GridState> _mapDragCancelledToState(
      GridDragCancelled cancelled) async* {
    yield Ready(currentState.grid);
  }

  List<List<String>> randomGrid() {
    List<List<String>> grid = [];
    var i = Random();

    for (int h = 0; h < height; h++) {
      List<String> row = [];
      for (int w = 0; w < width; w++) {
        var randomNumber = i.nextInt(5);
        row.add(circleVariants[randomNumber]);
      }
      grid.add(row);
    }
    return grid;
  }

  List<List<String>> changeCircles(int first, int second) {
    var x1 = xPos(first);
    var y1 = yPos(first);
    var x2 = xPos(second);
    var y2 = yPos(second);
    var gridCopy = currentState.grid;
    var circleVariant = gridCopy[x1][y1];
    gridCopy[x1][y1] = gridCopy[x2][y2];
    gridCopy[x2][y2] = circleVariant;
    return gridCopy;
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
