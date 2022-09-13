import 'package:flutter/material.dart';

var theme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  ),

  textButtonTheme: TextButtonThemeData(

  var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));  //GET요청
var result2 = jsonDecode(result.body);
// print(result2);
setState(() {
data = result2;
});
}

@override
void initState() {
  super.initState(); style: TextButton.styleFrom(
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
      actionsIconTheme: IconThemeData(color: Colors.black,
      )),
  textTheme: TextTheme(
    bodyText2: TextStyle(color: Colors.black),
  ),
);
