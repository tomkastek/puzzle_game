import 'package:puzzle_game/model/battle/CircleItem.dart';

class GridMocks {
  List<List<CircleItem>> threeBlueRow() {
    return [
      [
        CircleItem(CircleVariant.blue),
        CircleItem(CircleVariant.blue),
        CircleItem(CircleVariant.blue)
      ]
    ];
  }

  List<List<CircleItem>> threeBlueRowSolved() {
    return [
      [
        CircleItem(CircleVariant.solved),
        CircleItem(CircleVariant.solved),
        CircleItem(CircleVariant.solved)
      ]
    ];
  }

  List<List<CircleItem>> fiveBlueRow() {
    return [
      [
        CircleItem(CircleVariant.blue),
        CircleItem(CircleVariant.blue),
        CircleItem(CircleVariant.blue),
        CircleItem(CircleVariant.blue),
        CircleItem(CircleVariant.blue)
      ]
    ];
  }

  List<List<CircleItem>> fiveBlueRowSolved() {
    return [
      [
        CircleItem(CircleVariant.solved),
        CircleItem(CircleVariant.solved),
        CircleItem(CircleVariant.solved),
        CircleItem(CircleVariant.solved),
        CircleItem(CircleVariant.solved)
      ]
    ];
  }

  List<List<CircleItem>> threeBlueColumn() {
    return [
      [CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.blue)]
    ];
  }

  List<List<CircleItem>> threeBlueColumnSolved() {
    return [
      [CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved)]
    ];
  }

  List<List<CircleItem>> fiveBlueColumn() {
    return [
      [CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.blue)]
    ];
  }

  List<List<CircleItem>> fiveBlueColumnSolved() {
    return [
      [CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved)]
    ];
  }

  List<List<CircleItem>> threeInL() {
    return [
      [CircleItem(CircleVariant.blue), CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.blue), CircleItem(CircleVariant.dark)]
    ];
  }

  List<List<CircleItem>> cross() {
    return [
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.blue), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.blue), CircleItem(CircleVariant.blue), CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.blue), CircleItem(CircleVariant.dark)]
    ];
  }

  List<List<CircleItem>> crossSolved() {
    return [
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.dark)]
    ];
  }

  List<List<CircleItem>> hFormation() {
    return [
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.blue), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.blue), CircleItem(CircleVariant.dark)]
    ];
  }

  List<List<CircleItem>> hFormationSolved() {
    return [
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.blue), CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.blue), CircleItem(CircleVariant.solved)]
    ];
  }

  List<List<CircleItem>> tUpsideDown() {
    return [
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.blue), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark)]
    ];
  }

  List<List<CircleItem>> tUpsideDownSolved() {
    return [
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.blue), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.blue)],
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)]
    ];
  }

  List<List<CircleItem>> bigBlock() {
    return [
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark)],
      [CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark), CircleItem(CircleVariant.dark)]
    ];
  }

  List<List<CircleItem>> bigBlockSolved() {
    return [
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)],
      [CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved), CircleItem(CircleVariant.solved)]
    ];
  }
}
