import 'package:flutter/material.dart';

const colorList = <Color>[
  Colors.blue,
  Colors.teal,
  Colors.green,
  Colors.red,
  Colors.purple,
  Colors.deepPurple,
  Colors.orange,
  Colors.pink,
  Colors.pinkAccent,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
    : assert(selectedColor >= 0, 'Selected color must be greater than 0'),
      assert(
        selectedColor < colorList.length,
        'Selected color must be less or equal than ${colorList.length - 1}',
      );

  ThemeData getTheme() => ThemeData(
    // En Flutter 3.22+ Material 3 es el default.
    // colorSchemeSeed genera todo el ColorScheme M3 a partir del color elegido.
    colorSchemeSeed: colorList[selectedColor],
    appBarTheme: const AppBarTheme(centerTitle: false),
  );
}
