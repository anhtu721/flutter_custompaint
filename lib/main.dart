import 'package:flutter/material.dart';
import 'package:he_toa_do/page/mycustom_paint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Custom Paint',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyCustomPaint(),
    );
  }
}
