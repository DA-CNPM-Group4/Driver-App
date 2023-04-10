import 'package:flutter/material.dart';

final theme = ThemeData(
  appBarTheme:
      const AppBarTheme(elevation: 0, color: Colors.white, centerTitle: false),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
        color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
    displayMedium: TextStyle(color: Colors.black, fontSize: 15),
    displaySmall: TextStyle(color: Colors.black, fontSize: 12),
    bodyLarge: TextStyle(
        color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
  ),
  bottomSheetTheme:
      const BottomSheetThemeData(backgroundColor: Colors.transparent),
  backgroundColor: Colors.white,
  scaffoldBackgroundColor: Colors.white,
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                  side: BorderSide(color: Colors.green))))),
);
