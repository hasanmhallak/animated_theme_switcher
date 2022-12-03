import 'dart:ui';
import 'dart:math';

import 'package:flutter/material.dart';

class OvalClipper extends CustomClipper<Path> {
  final double sizeRatio;
  final Offset offset;

  OvalClipper(this.sizeRatio, this.offset);

  @override
  Path getClip(Size size) {
    return Path()
      ..addOval(
        Rect.fromCircle(
          center: offset,
          radius: lerpDouble(0, _calcMaxRadius(size, offset), sizeRatio)!,
        ),
      );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

  static double _calcMaxRadius(Size size, Offset center) {
    /// Always return the bigger radius to cover all the screen.
    final w = max(center.dx, size.width - center.dx);
    final h = max(center.dy, size.height - center.dy);

    /// ac = sqr(ab^2 + bc^2)
    return sqrt(w * w + h * h);
  }
}
