import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'dart:math' as math;

final particles = List<Particle>.generate(1000, (index) => Particle());

class Sky extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // canvas.drawColor(Colors.black, BlendMode.difference);

    Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (var p in particles) {
      p.pos += Offset(p.dx, p.dy);
    }

    for (var p in particles) {
      canvas.drawCircle(p.pos, p.radius, paint);
    }
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
  bool shouldRebuildSemantics(Sky oldDelegate) => true;
}

class Particle {
  Particle() {
    radius = Utils.range(0.1, 0.5);
    color = Colors.white;
    final x = Utils.range(0, 1000);
    final y = Utils.range(0, 180);
    pos = Offset(x, y);
    dx = Utils.range(-0.01, 0.01);
    dy = Utils.range(-0.01, 0.01);
  }
  late double radius;
  late Color color;
  late Offset pos;
  late double dx;
  late double dy;
}

final reg = math.Random();

class Utils {
  static double range(double min, double max) =>
      reg.nextDouble() * (max - min) + min;
}
