import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import './style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import './notification.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    //Provider를 여러 개 사용하기 위해서..
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (c) => Store1()),
      ChangeNotifierProvider(create: (c) => Store2()),
    ],
      // ChangeNotifierProvider(
      //   create: (c) => Store1(),
        child: MaterialApp(
            theme: style.theme,
            home: MyApp()
        ),
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
    initNotification(context);
    // saveData();
    getData();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('+'),
        onPressed: () {

          //정해진 시간에 알람 전송
          showNotification2();

          //클릭하면 알람 전송
          // showNotification();
        },
      ),
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

                      GestureDetector(
                        child: Text(widget.data[i]['user']),
                        onTap: (){
                          Navigator.push(context,
                              // CupertinoPageRoute(builder: (c) => Profile())
                            PageRouteBuilder(
                              pageBuilder: (c, a1, a2) => Profile(),
                              transitionsBuilder: (c, a1, a2, child) =>

                              // Fade 애니메이션 용 위젯
                              FadeTransition(opacity: a1, child: child),
                              
                              // Slide 애니메이션 용 위젯
                              // SlideTransition(
                              //     position: Tween(
                              //     begin: Offset(-1.0, 0.0),
                              //       end: Offset(0.0, 0.0),
                              //     ).animate(a1),
                              //     child: child)
                            )
                          );
                        },
                      ),

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

class Store2 extends ChangeNotifier {
  var name = 'taeyong';

  //state 변경 함수
  changeName() {
    name = 'dongjin';
    notifyListeners();  //재 렌더링하는 메서드
  }
}


// Provider 를 통한 state 관리
// store라고 명명한 이유는 그냥 창고라 생각
class Store1 extends ChangeNotifier {

  var follower = 0;
  var friend = false;   //지금 친구인지, 기본 값은 false
  var profileImage = [];

  getData() async{
    var result = await http.get(Uri.parse('https://codingapple1.github.io/app/profile.json'));

    var result2 = jsonDecode(result.body);
    profileImage = result2;
    notifyListeners();
  }

  addFollower(){
    if( friend == false){   // 친구가 아니면 follow를 할 수 있고 없고를 작성할 수 있음
      follower++;
      friend = true;
    } else {
      follower--;
      friend = false;
    }
    notifyListeners();
  }
}

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.watch<Store2>().name),),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: ProfileHeader(),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (c, i) => Image.network(context.watch<Store1>().profileImage[i]),
                childCount: context.watch<Store1>().profileImage.length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          )
        ],
      )

      // GridView.builder(
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      //   itemBuilder: (c, i) {
      //     return Container(color: Colors.grey);
      //   },
      //   itemCount: 3,
      // ),
    );
  }

  const Profile({Key? key}) : super(key: key);
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.grey,
        ),
        Text('팔로워 ${context.watch<Store1>().follower}명'),
        ElevatedButton(onPressed: (){
          context.read<Store1>().addFollower();
        }, child: Text('follow')),

        //사진가져오기
        ElevatedButton(onPressed: (){
          context.read<Store1>().getData();
        }, child: Text('사진가져오기')),
      ],
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