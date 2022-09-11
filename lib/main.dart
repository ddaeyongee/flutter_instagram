import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      theme: ThemeData(
        //스타일 모아놓는 ThemeData()
        iconTheme: IconThemeData(color: Colors.blue),
        appBarTheme: AppBarTheme(
            color: Colors.grey,
            actionsIconTheme: IconThemeData(color: Colors.blue)),
        textTheme: TextTheme(
          bodyText2: TextStyle( color : Colors.black ),
        )
      ),
      home: MyApp()));
}

// var a = TextStyle();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [Icon(Icons.star)],
      ),
      body: Icon(Icons.star),
    );
  }
}