
import 'package:flutter/material.dart';

class DrawerPainter extends CustomPainter {
  final Offset offset;

  DrawerPainter({this.offset});

  double getControlPoint(double width) {
    if (offset.dx == 0) {
      return width;
    } else
      return offset.dx > width ? offset.dx : width + 75;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    Path path = Path();
    // move the paint position
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    // path.lineTo(size.width, size.height);
    //dx,dy is controler
    path.quadraticBezierTo(
        getControlPoint(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
