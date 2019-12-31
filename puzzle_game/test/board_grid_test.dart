import 'package:flutter_test/flutter_test.dart';
import 'package:puzzle_game/model/battle/board_grid.dart';
import 'package:puzzle_game/model/battle/board_point.dart';

import 'board_grid_mocks.dart';

void main() {
  final gridMocks = GridMocks();
  test("Three in horizontal row get solved", () {
    final boardGrid = BoardGrid.random(1, 3);
    boardGrid.grid = gridMocks.threeBlueRow();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.threeBlueRowSolved());
  });

  test("Five in horizontal row get solved", () {
    final boardGrid = BoardGrid.random(1, 5);
    boardGrid.grid = gridMocks.fiveBlueRow();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.fiveBlueRowSolved());
  });

  test("Three in column get solved", () {
    final boardGrid = BoardGrid.random(3, 1);
    boardGrid.grid = gridMocks.threeBlueColumn();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.threeBlueColumnSolved());
  });

  test("Five in column get solved", () {
    final boardGrid = BoardGrid.random(5, 1);
    boardGrid.grid = gridMocks.fiveBlueColumn();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.fiveBlueColumnSolved());
  });

  test("Three in L get NOT solved", () {
    final boardGrid = BoardGrid.random(2, 2);
    boardGrid.grid = gridMocks.threeInL();
    boardGrid.resolve(BoardPoint(0,0));
    boardGrid.resolve(BoardPoint(0,1));
    boardGrid.resolve(BoardPoint(1,0));
    boardGrid.resolve(BoardPoint(1,1));

    expect(boardGrid.grid, gridMocks.threeInL());
  });

  test("Cross get solved", () {
    final boardGrid = BoardGrid.random(3, 3);
    boardGrid.grid = gridMocks.cross();
    boardGrid.resolve(BoardPoint(0,1));

    expect(boardGrid.grid, gridMocks.crossSolved());
  });

  test("H-Formation get solved", () {
    final boardGrid = BoardGrid.random(3, 3);
    boardGrid.grid = gridMocks.hFormation();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.hFormationSolved());
  });

  test("T-upsideDown get solved", () {
    final boardGrid = BoardGrid.random(3, 3);
    boardGrid.grid = gridMocks.tUpsideDown();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.tUpsideDownSolved());
  });

  test("bigBlock get solved", () {
    final boardGrid = BoardGrid.random(4, 4);
    boardGrid.grid = gridMocks.bigBlock();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.bigBlockSolved());
  });

  test("touching two rows get solved", () {
    final boardGrid = BoardGrid.random(2, 4);
    boardGrid.grid = gridMocks.twoTouchingRows();
    boardGrid.resolve(BoardPoint(1,0));

    expect(boardGrid.grid, gridMocks.twoTouchingRowsSolved());
  });

  test("touching rows get solved", () {
    final boardGrid = BoardGrid.random(3, 6);
    boardGrid.grid = gridMocks.threeTouchingRows();
    boardGrid.resolve(BoardPoint(2,0));

    expect(boardGrid.grid, gridMocks.threeTouchingRowsSolved());
  });

  test("touching columns get solved", () {
    final boardGrid = BoardGrid.random(6, 3);
    boardGrid.grid = gridMocks.threeTouchingColumns();
    boardGrid.resolve(BoardPoint(0,0));

    expect(boardGrid.grid, gridMocks.threeTouchingColumnsSolved());
  });

  test("correctItemPlacements works for only two items (XO)", () {
    final boardGrid = BoardGrid.random(2, 1);
    boardGrid.grid = gridMocks.twoBottomSolved();
    boardGrid.correctItemPlacements();

    expect(boardGrid.grid, gridMocks.twoBottomSolvedCorrectPlaced());
  });

  test("correctItemPlacements works for three bottom solved (XXO)", () {
    final boardGrid = BoardGrid.random(3, 1);
    boardGrid.grid = gridMocks.threeBottomSolved();
    boardGrid.correctItemPlacements();

    expect(boardGrid.grid, gridMocks.threeBottomSolvedCorrectPlaced());
  });

  test("correctItemPlacements works for three bottom solved (XXO)", () {
    final boardGrid = BoardGrid.random(3, 1);
    boardGrid.grid = gridMocks.threeBetweenSolved();
    boardGrid.correctItemPlacements();

    expect(boardGrid.grid, gridMocks.threeBetweenSolvedCorrectPlaced());
  });

  test("correctItemPlacements works for four with two solved between (XOXO)", () {
    final boardGrid = BoardGrid.random(4, 1);
    boardGrid.grid = gridMocks.fourTwoBetweenSolved();
    boardGrid.correctItemPlacements();

    expect(boardGrid.grid, gridMocks.fourTwoBetweenSolvedCorrectPlaced());
  });
}
