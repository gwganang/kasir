import 'package:flutter/material.dart';

// Menentukan warna tema utama
const Color primaryColor = Color(0xFF273F82); // Biru
const Color secondaryColor = Color(0xFFE6222E); // Merah
const Color accentColor = Color(0xFFCD9930); // Emas
const Color backgroundColor = Color(0xFFF0F0F0); // Putih

// Tema aplikasi
final ThemeData appTheme = ThemeData(
  primaryColor: primaryColor,
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue).copyWith(
    secondary: accentColor, // Ganti accentColor dengan secondary
  ),
  scaffoldBackgroundColor: backgroundColor, // Ganti backgroundColor dengan scaffoldBackgroundColor
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: primaryColor), // Body text untuk tampilan umum
    bodyMedium: TextStyle(color: secondaryColor), // Body text untuk tampilan lainnya
    bodySmall: TextStyle(color: secondaryColor), // Gaya teks kecil
    titleLarge: TextStyle(color: primaryColor, fontSize: 24, fontWeight: FontWeight.bold), // Judul besar
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,  // Ganti color menjadi backgroundColor
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: primaryColor, // Ganti primary menjadi buttonColor
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,  // Ganti primary menjadi backgroundColor
      foregroundColor: Colors.white,  // Ganti onPrimary menjadi foregroundColor
      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
    ),
  ),
  iconTheme: IconThemeData(color: primaryColor),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(color: primaryColor),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: primaryColor),
    ),
  ),
);
