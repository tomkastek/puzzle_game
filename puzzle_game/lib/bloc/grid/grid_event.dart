import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GridEvent extends Equatable {
  GridEvent([List props = const []]) : super(props);
}

class GridDragBegan extends GridEvent {
  final int index;

  GridDragBegan(this.index);

  @override
  String toString() => "Drag began";
}

class GridDragEnd extends GridEvent {
  @override
  String toString() => "Drag end";
}

class GridDragHovered extends GridEvent {
  final int to;

  GridDragHovered(this.to);

  @override
  String toString() => "Drag hovered to $to";
}

class ResolvedGrid extends GridEvent {
  final int checkedIndex;

  ResolvedGrid(this.checkedIndex);

  @override
  String toString() => "resolved Grid with last checked position: { $checkedIndex }";
}
