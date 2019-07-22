import 'dart:math';

import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';
import 'package:bloc/bloc.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  final List<String> circleVariants = ['R', 'B', 'G', 'Y', 'D'];
  final height = 5;
  final width = 6;

  @override
  void onEvent(GridEvent event) {
    if (event is GridDragHovered) {
      print(event.toString());
    }
  }

  @override
  GridState get initialState =>
      Ready(randomGrid(), width: width, height: height);

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
    yield Dragging(currentState.grid,
        width: currentState.width,
        height: currentState.height,
        draggedIndex: began.index);
  }

  Stream<GridState> _mapDragEndToState(GridDragEnd end) async* {
    if (end.initial == end.changeWith) {
      yield Ready(currentState.grid,
          width: currentState.width, height: currentState.height);
    } else {
      var gridCopy = changeCircles(end.initial, end.changeWith);
      yield Ready(gridCopy,
          width: currentState.width, height: currentState.height);
    }
  }

  Stream<GridState> _mapDragHoveredToState(GridDragHovered event) async* {
    var state = currentState;
    if (state is Dragging) {
      var gridCopy = changeCircles(state.draggedIndex, event.to);
      yield Dragging(gridCopy,
          width: currentState.width,
          height: currentState.height,
          draggedIndex: event.to);
    }
  }

  Stream<GridState> _mapDragCancelledToState(
      GridDragCancelled cancelled) async* {
    yield Ready(currentState.grid,
        width: currentState.width, height: currentState.height);
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
    var x1 = currentState.xPos(first);
    var y1 = currentState.yPos(first);
    var x2 = currentState.xPos(second);
    var y2 = currentState.yPos(second);
    var gridCopy = currentState.grid;
    var circleVariant = gridCopy[x1][y1];
    gridCopy[x1][y1] = gridCopy[x2][y2];
    gridCopy[x2][y2] = circleVariant;
    return gridCopy;
  }
}
