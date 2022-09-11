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

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var tab = 0;

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
      body: [Text('홈'),Text('샵페이지')][tab],  //가까운 Theme 을 찾아서 가져오기
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (i) {
          setState(() {
            tab = i;
          });
          print(i);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: '샾'),
        ],
      ),
    );
  }
}


////////////////////////////////////////////
// ( 참고 )  동적 UI 만드는 법
// 1. state 에  UI 의 현재상태 저장
// 2. state 에 따라 UI가 어떻게 보일지 작성
// 3. 유저가 쉽게 state 조작할 수 있게
////////////////////////////////////////////