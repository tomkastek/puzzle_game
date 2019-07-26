// TODO: String as identifier is not recommended. Change to enum or something else for object initialization
import 'package:flutter/material.dart';
import 'package:puzzle_game/battle/CircleItem.dart';

/// The item is build by a StringIdentifier right now.
/// Depending on the String an Icon will be build
/// R = Red item
/// G = Green item
/// B = Blue item
/// Y = Yellow item
/// D = Dark item
class BoardItem extends StatelessWidget {
  BoardItem({Key key, @required this.item, this.alpha = 255}) : super(key: key);

  final CircleItem item;
  final int alpha;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return item.getIcon(constraint.biggest.height, alpha: alpha);
    },);
  }
}