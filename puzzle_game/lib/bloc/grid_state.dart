import 'package:equatable/equatable.dart';

class GridState extends Equatable {
  List<List<String>> gridState;

  GridState([List props = const []]) : super(props) {
    gridState = [
      ['R', 'B', 'G', 'Y', 'D', 'R'],
      ['R', 'Y', 'D', 'D', 'R', 'G'],
      ['B', 'G', 'B', 'Y', 'Y', 'B'],
      ['R', 'G', 'G', 'B', 'D', 'R'],
      ['D', 'B', 'R', 'D', 'R', 'G'],
    ];
  }

  int numberOfRows() {
    return gridState.length;
  }

  int numberOfColumns() {
    return gridState.first.length;
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
