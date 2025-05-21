import 'package:flutter/material.dart';

ElevatedButtonThemeData getElevatedButtonTheme() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, // لون النص أو الأيقونة عند التفاعل
      backgroundColor: const Color(0xFFff9800), // لون خلفية الزر
      textStyle: const TextStyle(
        fontFamily: 'Rubik', // نوع الخط
        fontSize: 16, // حجم النص
        fontWeight: FontWeight.w400, // وزن النص
      ),
      minimumSize: const Size(340, 60), // الحجم الأدنى للزر
      elevation: 2, // الظل
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // زوايا دائرية
      ),
    ),
  );
}
