// TODO: String as identifier is not recommended. Change to enum or something else for object initialization
import 'package:flutter/material.dart';

/// The item is build by a StringIdentifier right now.
/// Depending on the String an Icon will be build
/// R = Red item
/// G = Green item
/// B = Blue item
/// Y = Yellow item
/// D = Dark item
class BoardItem extends StatelessWidget {
  BoardItem({Key key, @required this.itemIdentifier}) : super(key: key);

  String itemIdentifier;

  @override
  Widget build(BuildContext context) {
    switch (itemIdentifier) {
      case 'R':
        return CircleItem(color: Colors.red,);
        break;
      case 'B':
        return CircleItem(color: Colors.blue);
        break;
      case 'G':
        return CircleItem(color: Colors.green[700]);
        break;
      case 'Y':
        return CircleItem(color: Colors.yellow[600]);
        break;
      case 'D':
        return CircleItem(color: Colors.deepPurple);
        break;
      default:
        return Text(itemIdentifier.toString());
    }
  }
}

class CircleItem extends StatelessWidget {
  const CircleItem({Key key, @required this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Icon(
        Icons.blur_circular,
        size: constraint.biggest.height,
        color: color,
      );
    });
  }
}

