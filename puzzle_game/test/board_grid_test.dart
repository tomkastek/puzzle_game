import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_game/model/battle/board_grid.dart';
import 'package:puzzle_game/model/battle/board_point.dart';

import 'board_grid_mocks.dart';

void main() {
  var gridMocks = GridMocks();
  test("Three in horizontal row get solved", () {
    var boardGrid = BoardGrid.random(1, 3);
    boardGrid.grid = gridMocks.threeBlueRow();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.threeBlueRowSolved());
  });

  test("Five in horizontal row get solved", () {
    var boardGrid = BoardGrid.random(1, 5);
    boardGrid.grid = gridMocks.fiveBlueRow();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.fiveBlueRowSolved());
  });

  test("Three in column get solved", () {
    var boardGrid = BoardGrid.random(3, 1);
    boardGrid.grid = gridMocks.threeBlueColumn();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.threeBlueColumnSolved());
  });

  test("Five in column get solved", () {
    var boardGrid = BoardGrid.random(5, 1);
    boardGrid.grid = gridMocks.fiveBlueColumn();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.fiveBlueColumnSolved());
  });

  test("Three in L get NOT solved", () {
    var boardGrid = BoardGrid.random(2, 2);
    boardGrid.grid = gridMocks.threeInL();
    boardGrid.resolve(BoardPoint(0,0));
    boardGrid.resolve(BoardPoint(0,1));
    boardGrid.resolve(BoardPoint(1,0));
    boardGrid.resolve(BoardPoint(1,1));

    expect(boardGrid.grid, gridMocks.threeInL());
  });

  test("Cross get solved", () {
    var boardGrid = BoardGrid.random(3, 3);
    boardGrid.grid = gridMocks.cross();
    boardGrid.resolve(BoardPoint(0,1));

    expect(boardGrid.grid, gridMocks.crossSolved());
  });

  test("H-Formation get solved", () {
    var boardGrid = BoardGrid.random(3, 3);
    boardGrid.grid = gridMocks.hFormation();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.hFormationSolved());
  });
}
