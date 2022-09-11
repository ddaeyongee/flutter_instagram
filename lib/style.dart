import 'package:flutter/material.dart';

var theme = ThemeData(
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
    backgroundColor: Colors.grey,
  )),
  elevatedButtonTheme: ElevatedButtonThemeData(
      style: TextButton.styleFrom(
    backgroundColor: Colors.grey,
  )),
  appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1, //그림자크기
      titleTextStyle: TextStyle(color: Colors.black, fontSize: 25),
      actionsIconTheme: IconThemeData(color: Colors.black)),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.red),
  ),
);
