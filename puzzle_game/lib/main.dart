import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'application.dart';

void main() {
  /// Game only playable in portait mode.
  /// Otherwise the board can not be build correctly
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);

  return runApp(BoardPuzzleApp());
}
