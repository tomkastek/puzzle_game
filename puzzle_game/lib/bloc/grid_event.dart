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
  final int initial;
  final int changeWith;

  GridDragEnd(this.initial, this.changeWith);

  @override
  String toString() => "Drag end { initial: $initial, vhangeWith: $changeWith }";
}

class GridDragCancelled extends GridEvent {
  @override
  String toString() => "Drag canceleld";
}

class GridDragHovered extends GridEvent {
  final int to;

  GridDragHovered(this.to);

  @override
  String toString() => "Drag hovered to $to";
}
