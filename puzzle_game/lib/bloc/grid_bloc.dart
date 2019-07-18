import 'package:puzzle_game/bloc/grid_event.dart';
import 'package:puzzle_game/bloc/grid_state.dart';
import 'package:bloc/bloc.dart';

class GridBloc extends Bloc<GridEvent, GridState> {
  @override
  // TODO: implement initialState
  GridState get initialState => GridState();

  @override
  Stream<GridState> mapEventToState(GridEvent event) async* {
    yield currentState;
  }
}