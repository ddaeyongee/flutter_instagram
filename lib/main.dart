import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
      MaterialApp(
          theme: style.theme,
          home: MyApp()
      )
  );
}

// ! 중요
// 페이지가 많으면 아래와 같이 routes 를 사용
// 복잡한 앱에 좋음

// void main() {
//   runApp(MaterialApp(
//     theme: style.theme,
//     initialRoute: '/',
//     routes: {
//       '/': (c) => Text('첫페이지'),
//       '/detail': (c) => Text('둘째페이지')
//     },
//   ));
// }

// var a = TextStyle();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var tab = 0;
  var data = [];
  var userImage;
  var userContent;

  saveData() async{
    //봤던 데이타는 빠르게 로드되고, 서버와 주고받는 데이타양을 줄일 수 있음
    //앱결 때 shared_preferences에 있는 게시물을 가져올 수 있을 것
    var storage = await SharedPreferences.getInstance();
    storage.setString('name', 'john');
    // storage.setBool('name', true);
    // storage.setInt('name', 20);
    // storage.setDouble('name', 20.5);
    // storage.setStringList('name', ['john', 'park']);
    // storage.remove('name');
    var result = storage.get('name');
    print(result);

  }

  addMyData(){
    var myData = {
      'id': data.length,
      'image': userImage,
      'likes': 5,
      'date': 'July 25',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };
    setState(() {
      data.insert(0, myData);
    });
  }


  setUserContent(a){
    setState(() {
      userContent = a;
    });
  }

  addData(a) {
    setState(() {
      data.add(a);
    });
  }

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/data.json'));  //GET요청
    var result2 = jsonDecode(result.body);
    // print(result2);
    setState(() {
      data = result2;
    });
   }

  @override
  void initState() {
    super.initState();

    saveData();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Instagram clone'),
          actions: [
        IconButton(
          icon: Icon(Icons.add_box_outlined),
          onPressed: () async {
            var picker = ImagePicker();
            var image = await picker.pickImage(source: ImageSource.gallery);
            if ( image != null ) {
              setState(() {
                userImage = File(image.path);
              });
            }
            // Image.file(userImage);

            Navigator.push(context, // 새 페이지 띄울 때 Navigator 사용
                MaterialPageRoute(builder: (c) => Upload(
                    userImage : userImage,
                    setUserContent: setUserContent,
                    addMyData : addMyData
                ))   //함수 내 return 을 => 로 대체할 수 있음
            );
          },
          iconSize: 30,
        )
      ]),

      // body: TextButton(
      //   onPressed: (){},
      //   child: Text('테스트'),
      // ),
      body: [Home(data: data, addData : addData), Text('샵페이지')][tab],  //가까운 Theme 을 찾아서 가져오기
      // body: [FutureBuilder(future: data, builder: (){}), Text('샵페이지')][tab],
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

// 부모
class Home extends StatefulWidget {
  const Home({Key? key, this.data, this.addData}) : super(key: key);
  final data;
  final addData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  var scroll = ScrollController();  //유저가 스크롤 했던 데이타를 체크

  getMore() async {
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.addData(result2);
  }
  //위치 측정은 스크롤 움직일 때마다 해야 함
  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      // print(scroll.position.pixels);  // 스크롤 바를 내린 거리 위치 측정
      // print(scroll.position.maxScrollExtent); // 스크롤 최대 내린 거리 위치
      // print(scroll.position.userScrollDirection); // 스크롤 방향
      if(scroll.position.pixels == scroll.position.maxScrollExtent){
        // print('같음');
        getMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isNotEmpty) {
      return ListView.builder(
          itemCount: 3,
          controller: scroll,
          itemBuilder: (c, i) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image.network('https://codingapple1.github.io/kona.jpg'),
                Container(
                  constraints: BoxConstraints(maxWidth: 600),
                  padding: EdgeInsets.all(20),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 삼항 연산자 1== 1 ? '진실' : '거짓'
                      widget.data[i]['image'].runtimeType == String
                          ? Image.network(widget.data[i]['image'])
                          : Image.file(widget.data[i]['image']),
                      Text('좋아요 ${widget.data[i]['likes']}'),
                      Text(widget.data[i]['date']),
                      Text(widget.data[i]['content']),
                    ],
                  ),
                )
              ],
            );
          });
    } else {
      return Text('로딩중');
    }
  }
}

class Upload extends StatelessWidget {
  const Upload({Key? key, this.userImage, this.setUserContent, this.addMyData}) : super(key: key);
  final userImage;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            addMyData();
          }, icon: Icon(Icons.send))
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.file(userImage),
          // Image.asset(userImage),
          Text('이미지 업로드 화면'),
          TextField(onChanged: (text){
            setUserContent(text);
          }),
          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.close))
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


////////////////////////////////////////////
// ( 참고 )  데이터보존방법
// 1. 서버에 보내서 DB 에 저장
// 2. 폰 메모리카드에 저장(shared preferences 이용) 중요한건 DB에 ~
////////////////////////////////////////////