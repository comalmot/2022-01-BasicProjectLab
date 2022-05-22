import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'boong_infoEdit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '영업일시 및 장소 수정',
      home: customer_main(),
    );
  }
}

class customer_main extends StatefulWidget {
  @override
  customer_mainState createState() => customer_mainState();
}

class customer_mainState extends State<customer_main> {
  String url = ""; // 띄울 웹 페이지의 주소
  Set<JavascriptChannel>? channel;
  WebViewController? controller;

  // Bottom Navigation Bar 관련 변수
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      index == 0
          ? _drawerKey.currentState!.openDrawer()
          : setState(() {
              _selectedIndex = index;
            });
    });
  }

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      key: _drawerKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              child: Text(
                '카테고리',
                style: TextStyle(fontSize: 24),
              ),
              decoration: BoxDecoration(
                color: Colors.grey,
              ),
            ),
            ListTile(
              title: Text('붕어빵'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('문어빵'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('츄러스'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('호떡'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('크레페'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('돈가스'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('아이스크림'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('닭꼬치'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('떡볶이'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('순대'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: ClipRect(
            child: Transform.scale(
          scale: ratio,
          child: WebView(
            initialUrl: "http://boongsaegwon.kro.kr",
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            javascriptChannels: channel,
            javascriptMode: JavascriptMode.unrestricted,
          ),
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: '카테고리',
            backgroundColor: Colors.green,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
            backgroundColor: Colors.red,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: '즐겨찾기',
            backgroundColor: Colors.purple,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
