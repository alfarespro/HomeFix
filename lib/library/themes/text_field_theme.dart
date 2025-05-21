import 'package:flutter/material.dart';

InputDecorationTheme getTextFieldTheme() {
  return const InputDecorationTheme(
    labelStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Colors.grey,
      fontFamily: 'Rubik',
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 2),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(color: Color(0xFFE0E8FF), width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
  );
}

TextStyle getTextFieldTextStyle() {
  return const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontFamily: 'Rubik',
  );
}
