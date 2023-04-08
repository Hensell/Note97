import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:math' as math;

class SkyNight extends CustomPainter {
  final double radius;

  SkyNight(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = radius;

    Path path = Path();
    // Adds a polygon from the starting point to quarter point of the screen and lastly
    // it will be in the bottom middle. Close method will draw a line between start and end.
    path.addPolygon([
      Offset(0, size.height / 2),
      Offset(size.width / 2, size.height),
      Offset(size.width, size.height / 2),
      Offset(size.width / 2, 0)
    ], true);

    /*     Path clippedPath = Path.combine(
          PathOperation.intersect,
          path,
          Path()
            ..lineTo(size.width * 300, size.height)
            ..lineTo(0, size.height)
            ..close());*/
    canvas.drawPath(path, paint);
    //  canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Sky extends CustomPainter {
  final double value;

  const Sky(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = value;

    Path path = Path();
    double max = 2 * math.pi;

    double width = size.width / 2;
    double halfWidth = width / 2;

    double wingRadius = halfWidth;
    double radius = halfWidth / 2;

    double degreesPerStep = (360 / 5) * (math.pi / 180.0);
    double halfDegreesPerStep = degreesPerStep / 2;

    path.moveTo(width, halfWidth);

    for (double step = 0; step < max; step += degreesPerStep) {
      path.lineTo(halfWidth + wingRadius * math.cos(step),
          halfWidth + wingRadius * math.sin(step));
      path.lineTo(halfWidth + radius * math.cos(step + halfDegreesPerStep),
          halfWidth + radius * math.sin(step + halfDegreesPerStep));
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  SemanticsBuilderCallback get semanticsBuilder {
    return (Size size) {
      // Annotate a rectangle containing the picture of the sun
      // with the label "Sun". When text to speech feature is enabled on the
      // device, a user will be able to locate the sun on this picture by
      // touch.
      var rect = Offset.zero & size;
      var width = size.shortestSide * 0.4;
      rect = const Alignment(0.8, -0.9).inscribe(Size(width, width), rect);
      return [
        CustomPainterSemantics(
          rect: rect,
          properties: const SemanticsProperties(
            label: 'Sun',
            textDirection: TextDirection.ltr,
          ),
        ),
      ];
    };
  }

  // Since this Sky painter has no fields, it always paints
  // the same thing and semantics information is the same.
  // Therefore we return false here. If we had fields (set
  // from the constructor) then we would return true if any
  // of them differed from the same fields on the oldDelegate.
  @override
  bool shouldRepaint(Sky oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(Sky oldDelegate) => false;
}
