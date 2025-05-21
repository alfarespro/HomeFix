import 'package:flutter/material.dart';

AppBarTheme getAppBarTheme() {
  return const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 22,
      fontWeight: FontWeight.w500,
      fontFamily: 'Rubik',
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
      size: 30,
    ),
  );
}

ButtonStyle getBackButtonStyle() {
  return IconButton.styleFrom(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15),
    ),
    padding: const EdgeInsets.all(10),
    minimumSize: const Size(60, 60),
  );
}
