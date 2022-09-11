import 'package:flutter/material.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));  //GET요청
    var result2 = jsonDecode(result.body);
    print(jsonDecode(result.body));
  }

  @override
  void initState() {
    super.initState();

    getData();
  }
  
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
      body: [Home(), Text('샵페이지')][tab],  //가까운 Theme 을 찾아서 가져오기
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

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 3, 
        itemBuilder: (c, i){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network('https://codingapple1.github.io/kona.jpg'),
              Container(
                constraints: BoxConstraints(maxWidth: 600),
                padding: EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('좋아요 100'),
                    Text('글쓴이'),
                    Text('글내용'),
                  ],
                ),
              )
            ],
          );
        });
  }
}




////////////////////////////////////////////
// ( 참고 )  동적 UI 만드는 법
// 1. state 에  UI 의 현재상태 저장
// 2. state 에 따라 UI가 어떻게 보일지 작성
// 3. 유저가 쉽게 state 조작할 수 있게
////////////////////////////////////////////