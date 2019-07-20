import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class GridEvent extends Equatable {
  GridEvent([List props = const []]) : super(props);
}

class GridDragBegan extends GridEvent {
  @override
  String toString() => "Drag began";
}
