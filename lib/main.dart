import 'package:flutter/material.dart';
import './style.dart' as style;

void main() {
  runApp(
      MaterialApp(
          theme: style.theme,
          home: MyApp()
      )
  );
}

// var a = TextStyle();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instagram clone'), actions: [
        IconButton(
          icon: Icon(Icons.add_box_outlined),
          onPressed: () {},
          iconSize: 30,
        )
      ]),

      // body: TextButton(
      //   onPressed: (){}, 
      //   child: Text('테스트'),
      // ),
      body: Text('안녕', style: Theme.of(context).textTheme.bodyText2,),  //가까운 Theme 을 찾아서 가져오기
    );
  }
}
