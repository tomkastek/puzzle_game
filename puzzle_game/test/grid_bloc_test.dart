import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_game/bloc/grid/grid_bloc.dart';
import 'package:puzzle_game/bloc/grid/grid_state.dart';

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
      expect(gridBloc.initialState.grid.width, 6);
    });

    test('initial height is 5', () {
      expect(gridBloc.initialState.grid.height, 5);
    });
  });
}
