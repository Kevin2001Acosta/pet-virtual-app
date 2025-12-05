import 'package:flutter/material.dart';

const Color _customColorPurple = Color.fromARGB(255, 218, 206, 233);

const List<Color> _colorsThemes = [
  _customColorPurple,
  Colors.black,
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.yellow,
  Colors.orange,
  Colors.pink,
  Colors.purple,
];

class AppTheme {
  final int selectedColor;

  AppTheme({this.selectedColor = 0})
      : assert(selectedColor >= 0 && selectedColor < _colorsThemes.length,
            'Invalid color');

  ThemeData theme() {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: _colorsThemes[selectedColor],
    );
  }
}
