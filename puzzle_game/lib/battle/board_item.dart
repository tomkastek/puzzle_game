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
      case '':
        return Text('');
        break;
      case 'R':
        return LayoutBuilder(builder: (context, constraint) {
          return Icon(
            Icons.blur_circular,
            size: constraint.biggest.height,
            color: Colors.red,
          );
        });
        break;
      case 'B':
        return LayoutBuilder(builder: (context, constraint) {
          return Icon(
            Icons.blur_circular,
            size: constraint.biggest.height,
            color: Colors.blue,
          );
        });
        break;
      case 'G':
        return LayoutBuilder(builder: (context, constraint) {
          return Icon(
            Icons.blur_circular,
            size: constraint.biggest.height,
            color: Colors.green[700],
          );
        });
        break;
      case 'Y':
        return LayoutBuilder(builder: (context, constraint) {
          return Icon(
            Icons.blur_circular,
            size: constraint.biggest.height,
            color: Colors.yellow[600],
          );
        });
        break;
      case 'D':
        return LayoutBuilder(builder: (context, constraint) {
          return Icon(
            Icons.blur_circular,
            size: constraint.biggest.height,
            color: Colors.deepPurple,
          );
        });
        break;
      default:
        return Text(itemIdentifier.toString());
    }
  }
}
