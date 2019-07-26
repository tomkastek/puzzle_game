import 'package:flutter/material.dart';

enum CircleVariant { red, blue, green, dark, light }

class CircleItem {
  final CircleVariant variant;

  CircleItem(this.variant);

  Icon getIcon(double size, {int alpha = 255}) {
    switch (variant) {
      case CircleVariant.red:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.red.withAlpha(alpha));
      case CircleVariant.blue:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.blue.withAlpha(alpha));
      case CircleVariant.green:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.green[700].withAlpha(alpha));
      case CircleVariant.dark:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.yellow[600].withAlpha(alpha));
      case CircleVariant.light:
        return Icon(Icons.blur_circular,
            size: size, color: Colors.deepPurple.withAlpha(alpha));
    }
    return null;
  }
}
