import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:vector_math/vector_math_64.dart' show Vector3;

class MyCustomPaint extends StatefulWidget {
  const MyCustomPaint({super.key});

  @override
  State<MyCustomPaint> createState() => _MyCustomPaintState();
}

class _MyCustomPaintState extends State<MyCustomPaint> {
  double _initScale = 1;
  double _scaleFactor = 1;
  // double _rotation = 1;

  double _topValue = 0;
  double _leftValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Paint'),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: _topValue,
            left: _leftValue,
            child: GestureDetector(
              //drag
              onPanUpdate: ((details) => setState(() {
                    _topValue += details.delta.dy;
                    _leftValue += details.delta.dx;
                  })),
              child: Stack(
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CustomPaint(
                      painter: Hexagon(),
                      child: Container(),
                    ),
                  ),
                  GestureDetector(
                    //The pointers in contact with the screen have established a focal point and initial scale of 1.0
                    onScaleStart: (details) {
                      setState(() {
                        _initScale = _scaleFactor;
                      });
                    },
                    // The pointers in contact with the screen have indicated a new scale.
                    onScaleUpdate: (details) {
                      setState(() {
                        _initScale = _scaleFactor * details.scale;
                      });
                    },
                    // The pointers are no longer in contact with the screen
                    onScaleEnd: (details) {
                      setState(() {
                        _scaleFactor = 1;
                      });
                    },

                    child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.diagonal3(
                          Vector3(_initScale, _initScale, _initScale)),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        child: Stack(
                          children: <Widget>[
                            CustomPaint(
                              painter: ShapePainter(),
                              child: Container(),
                            ),
                            CustomPaint(
                              painter: PointPainter(),
                              child: Container(),
                            ),
                            CustomPaint(
                              painter: OxyCoordinate(),
                              child: Container(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//custom paint
class OxyCoordinate extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Oxy coordinate system
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // Fistpoint x-axis
    Offset leftPoint = Offset(-10000, size.height / 2);
    // endpoint x-axis
    Offset rightPoint = Offset(10000, size.height / 2);
    // firstpoint y-axis
    Offset topPoint = Offset(size.width / 2, -10000);
    // endpoint y-axis
    Offset bottomPoint = Offset(size.width / 2, 10000);
    //arrow
    // Offset aPoint = Offset(size.width, size.height / 2);
    // Offset bPoint = Offset(size.width * 0.98, size.height / 2 * 1.02);
    // Offset cPoint = Offset(size.width * 0.98, size.height / 2 * 0.98);
    // //arow
    // Offset dPoint = Offset(size.width / 2, size.height);
    // Offset ePoint = Offset(size.width / 2 * 0.98, size.height * 0.98);
    // Offset fPoint = Offset(size.width / 2 * 1.02, size.height * 0.98);
    // x-axis
    canvas.drawLine(leftPoint, rightPoint, paint);
    //y-axis
    canvas.drawLine(topPoint, bottomPoint, paint);

    var paintArow = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;

    Path pathArrow1 = Path();
    pathArrow1.moveTo(size.width / 2, size.height);
    pathArrow1.lineTo(size.width / 2 * 0.98, size.height * 0.98);
    pathArrow1.lineTo(size.width / 2 * 1.02, size.height * 0.98);
    pathArrow1.lineTo(size.width / 2, size.height);
    pathArrow1.close();

    canvas.drawPath(pathArrow1, paintArow);
    Path pathArrow2 = Path();
    pathArrow2.moveTo(size.width, size.height / 2);
    pathArrow2.lineTo(size.width * 0.98, size.height / 2 * 1.02);
    pathArrow2.lineTo(size.width * 0.98, size.height / 2 * 0.98);
    pathArrow2.lineTo(size.width, size.height / 2);
    pathArrow2.close();

    canvas.drawPath(pathArrow2, paintArow);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class PointPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paintPoint = Paint()
      ..color = Colors.black
      ..strokeWidth = 5;
    //list of points
    final points = [
      Offset(size.width / 2, size.height / 2 - size.height * 0.05),
      Offset(size.width / 2, size.height / 2 - size.height * 0.1),
      Offset(size.width / 2, size.height / 2 - size.height * 0.15),
      Offset(size.width / 2, size.height / 2 + size.height * 0.05),
      Offset(size.width / 2, size.height / 2 + size.height * 0.1),
      Offset(size.width / 2, size.height / 2 + size.height * 0.15),
      Offset(size.width / 2 + size.height * 0.05, size.height / 2),
      Offset(size.width / 2 + size.height * 0.1, size.height / 2),
      Offset(size.width / 2 + size.height * 0.15, size.height / 2),
      Offset(size.width / 2 - size.height * 0.05, size.height / 2),
      Offset(size.width / 2 - size.height * 0.1, size.height / 2),
      Offset(size.width / 2 - size.height * 0.15, size.height / 2),
    ];
    //draw points on canvas
    canvas.drawPoints(PointMode.points, points, paintPoint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Rectangle
    final double widthRec = size.width * 0.4; // width
    final double heightRec = 2 * widthRec / 3; //height
    //setting the paint for Rectangle
    final Paint rec = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    //Creating a rectangle with size and width
    canvas.drawRect(
        Rect.fromLTRB(
            size.width * 0.15, size.height * 0.3, widthRec, heightRec),
        rec);

    //Circle

    final Paint circle = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    //Center of the circle
    Offset center = Offset(size.width * 0.8, size.height / 2 * 1.2);
    // Creating a circle with center of the circle, circle radius = size.with*0.8
    canvas.drawCircle(center, size.width * 0.08, circle);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

//hexagon
class Hexagon extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    //Hexagon
    Paint hex = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    //create path to form the Hexagon
    Path hexPath = Path();
    hexPath.moveTo(size.width * 0.7, size.height * 0.2);
    hexPath.lineTo(size.width * 0.8, size.height * 0.2);
    hexPath.lineTo(size.width * 0.85, size.height * 0.25);
    hexPath.lineTo(size.width * 0.8, size.height * 0.3);
    hexPath.lineTo(size.width * 0.7, size.height * 0.3);
    hexPath.lineTo(size.width * 0.65, size.height * 0.25);
    hexPath.lineTo(size.width * 0.7, size.height * 0.2);
    hexPath.close();
    hexPath.close();
    canvas.drawPath(hexPath, hex);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
