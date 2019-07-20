import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GridEvent extends Equatable {
  GridEvent([List props = const []]) : super(props);
}

class GridDragBegan extends GridEvent {
  final int index;
  final Offset position;

  GridDragBegan({@required this.index, @required this.position})
      : super([index, position]);

  @override
  String toString() => "Drag began";
}
