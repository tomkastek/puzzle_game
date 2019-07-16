import 'package:flutter/material.dart';

class Board extends StatelessWidget {
  // TODO: handle the state not here. Use inheritedwidget, provider or BLoC and a grid class.
  List<List<String>> gridState = [
    ['R', 'B', 'G', 'Y', 'D', 'R'],
    ['R', 'Y', 'D', 'D', 'R', 'G'],
    ['B', 'G', 'B', 'Y', 'Y', 'B'],
    ['R', 'G', 'G', 'B', 'D', 'R'],
    ['D', 'B', 'R', 'D', 'R', 'G'],
  ];

  @override
  Widget build(BuildContext context) {
    var gridStateLength = gridState.length * gridState.first.length;
    return Column(children: <Widget>[
      Container(
        height: 5 / 6 * MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.width,
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(), // disable scrolling
          crossAxisCount: 6,
          childAspectRatio: 1,
          children: List.generate(gridStateLength, (index) {
            return BoardField(
              gridState: gridState,
              index: index,
            );
          }),
        ),
      ),
    ]);
  }
}

/// This class sets up one field of the board of the game
/// gridState and index are used to get the x/y coordinates of the field to set up
/// The background of the field and a border around the field will be set
/// The item of the gridState at x/y a will be displayed on the field.
class BoardField extends StatelessWidget {
  BoardField({Key key, @required this.gridState, this.index}) : super(key: key);

  List<List<String>> gridState;
  int index;

  @override
  Widget build(BuildContext context) {
    int x, y = 0;
    x = (index / gridState.first.length).floor();
    y = (index % gridState.first.length);
    var dark = x % 2 == 0 ? index % 2 == 0 : index % 2 == 1;

    return GestureDetector(
      onTap: () => _gridItemTapped(x, y),
      child: GridTile(
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.5),
              color: dark ? Colors.brown[500] : Colors.brown[700]),
          child: Center(
            child: BoardItem(
              itemIdentifier: gridState[x][y],
            ),
          ),
        ),
      ),
    );
  }

  void _gridItemTapped(int x, int y) {}
}

// TODO: String as identifier is not recommended. Change to enum or something else for object initialization
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
