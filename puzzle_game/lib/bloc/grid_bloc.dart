import 'dart:math';

import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';
import 'package:bloc/bloc.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  final List<String> circleVariants = ['R', 'B', 'G', 'Y', 'D'];
  final height = 5;
  final width = 6;

  @override
  GridState get initialState =>
      Ready(randomGrid(), width: width, height: height);

  @override
  Stream<GridState> mapEventToState(GridEvent event) async* {
    if (event is GridDragBegan) {
      yield* _mapDragBeganToState(event);
    } else {
      yield currentState;
    }
  }

  Stream<GridState> _mapDragBeganToState(GridDragBegan began) async* {
    yield Dragging(currentState.grid,
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
}
