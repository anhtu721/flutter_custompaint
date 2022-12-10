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
        children: [
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
                children: [
                  Positioned(
                    //Zoom
                    child: GestureDetector(
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
                          child: CustomPaint(
                            painter: ShapePainter(),
                            child: Container(),
                          ),
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
class ShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Oxy coordinate system
    var paint = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    // Fistpoint x-axis
    Offset leftPoint = Offset(0, size.height / 2);
    // endpoint x-axis
    Offset rightPoint = Offset(size.width, size.height / 2);
    // firstpoint y-axis
    Offset topPoint = Offset(size.width / 2, 0);
    // endpoint y-axis
    Offset bottomPoint = Offset(size.width / 2, size.height);
    //arrow
    Offset aPoint = Offset(size.width, size.height / 2);
    Offset bPoint = Offset(size.width * 0.99, size.height / 2 * 1.01);
    Offset cPoint = Offset(size.width * 0.99, size.height / 2 * 0.99);
    //arow
    Offset dPoint = Offset(size.width / 2, 0);
    Offset ePoint = Offset(size.width / 2 * 0.99, 10 * 0.99);
    Offset fPoint = Offset(size.width / 2 * 1.01, 10 * 0.99);
    // x-axis
    canvas.drawLine(leftPoint, rightPoint, paint);
    //y-axis
    canvas.drawLine(topPoint, bottomPoint, paint);

    var paintArow = Paint()
      ..color = Colors.teal
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(aPoint, bPoint, paintArow);
    canvas.drawLine(cPoint, aPoint, paintArow);
    canvas.drawLine(bPoint, cPoint, paintArow);

    canvas.drawLine(dPoint, ePoint, paintArow);
    canvas.drawLine(ePoint, fPoint, paintArow);
    canvas.drawLine(fPoint, dPoint, paintArow);
    //Rectangle
    final double widthRec = size.width * 0.3; // width
    final double heightRec = 2 * widthRec / 3; //height
    //setting the paint for Rectangle
    final Paint rec = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    //Creating a rectangle with size and width
    canvas.drawRect(Rect.fromLTRB(25, 30, widthRec, heightRec), rec);

    //Circle

    final Paint circle = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill
      ..strokeCap = StrokeCap.round;
    //Center of the circle
    Offset center = Offset(size.width * 0.8, size.height / 2 * 1.2);
    // Creating a circle with center of the circle, circle radius = size.with*0.8
    canvas.drawCircle(center, size.width * 0.08, circle);

    //Hexagon
    Paint hex = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    //create path to form the Hexagon
    Path hexPath = Path();
    hexPath.moveTo(size.width * 0.7000000, size.height * 0.1574803);
    hexPath.lineTo(size.width * 0.7980000, size.height * 0.1574803);
    hexPath.lineTo(size.width * 0.8980000, size.height * 0.2346457);
    hexPath.lineTo(size.width * 0.7980000, size.height * 0.3149606);
    hexPath.lineTo(size.width * 0.6980000, size.height * 0.3133858);
    hexPath.lineTo(size.width * 0.5980000, size.height * 0.2346457);
    hexPath.lineTo(size.width * 0.7000000, size.height * 0.1574803);
    hexPath.close();
    hexPath.close();
    canvas.drawPath(hexPath, hex);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
