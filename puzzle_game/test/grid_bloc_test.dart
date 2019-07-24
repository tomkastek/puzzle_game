import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_game/bloc/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';

void main() {
  group('GridBloc', () {
    GridBloc gridBloc;

    setUp(() {
      gridBloc = GridBloc();
    });

    test('initial state is Ready', () {
      expect(gridBloc.initialState.runtimeType, Ready);
    });

    test('initial width is 6', () {
      expect(gridBloc.initialState.grid[0].length, 6);
    });

    test('initial height is 5', () {
      expect(gridBloc.initialState.grid.length, 5);
    });

    test('drag changes state to Dragging', () {
      final List<Type> expected = [Ready, Dragging];

      expectLater(
        gridBloc.state.runtimeType,
        emitsInOrder(expected),
      );

      gridBloc.dispatch(GridDragBegan(0));
    });


  });
}