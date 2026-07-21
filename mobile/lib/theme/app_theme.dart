import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
    fontFamily: 'Roboto',
    cardTheme: const CardThemeData(
      elevation: 8,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
  );
}
