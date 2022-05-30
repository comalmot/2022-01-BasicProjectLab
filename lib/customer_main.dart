import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'boong_infoEdit.dart';
import 'package:bottom_drawer/bottom_drawer.dart';

void main() => runApp(MyApp());

class storeInfo {
  String category = "";
  String? error;
  List<Map<String, dynamic>>? menu_info;
  String name = "";
  bool ok = false;
  String? store_description;
  String store_name = "";
  List<String>? store_open_info;
  List<String>? store_photo;

  storeInfo(
      this.category,
      this.error,
      this.menu_info,
      this.name,
      this.ok,
      this.store_description,
      this.store_name,
      this.store_open_info,
      this.store_photo);

  storeInfo.fromJson(Map<String, dynamic> json)
      : category = json['category'],
        error = json['error'],
        menu_info = json['menu_info']['menu'],
        name = json['name'],
        ok = json['ok'],
        store_description = json['store_description'],
        store_name = json['store_name'],
        store_open_info = json['store_open_info']['information'],
        store_photo = json['store_photo']['photo_urls'];

  Map<String, dynamic> toJson() => {
        'category': category,
        'error': error,
        'menu_info': menu_info,
        'name': name,
        'ok': ok,
        'store_description': store_description,
        'store_name': store_name,
        'store_open_info': store_open_info,
        'store_photo': store_photo,
      };
}

class Markers {
  double latitude = 0.0;
  double longitude = 0.0;
  bool is_open = false;
  String id = "";
}

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

  WebViewController? controller;

  // Bottom Navigation Bar 관련 변수
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  GlobalKey<ScaffoldState> _BottomdrawerKey = GlobalKey();

  void _getNowLocation() async {
    /*
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      controller!.runJavascript(
          //'setMarker(${position.latitude},${position.longitude})'
          'setinitMap(${position.latitude},${position.longitude});getAllLocations();');
    }
    */

    controller!
        .runJavascript('setinitMap(36.366522, 127.344574);getAllLocations();');
  }

  void _onItemTapped(int index) {
    setState(() {
      index == 0
          ? _drawerKey.currentState!.openDrawer()
          : setState(() {
              _selectedIndex = index;
            });
      index == 2
          ? showFavorites()
          : setState(() {
              _selectedIndex = index;
            });
    });
  }

  showFavorites() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 700,
          color: Colors.amber,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text('Modal BottomSheet'),
                ElevatedButton(
                    child: const Text('Close BottomSheet'),
                    onPressed: () {
                      _selectedIndex = 1;
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        );
      },
    );
  }
/*
  Widget buildMyImage(BuildContext context, List<Widget>? Images) {
    return Container(
      height: 900,
      child: Images,
    );
  }
*/

  showStoreInfo(JavascriptMessage jsMessage) {
    Map<String, dynamic> responseMap = jsonDecode(jsMessage.message);
    var user = storeInfo.fromJson(responseMap);
    List<Widget> _storeImageWidgetList = [];

    var store_Photos = user.store_photo;

    if (store_Photos != null) {
      for (var item in store_Photos) {
        _storeImageWidgetList!.add(
          Row(
            children: <Widget>[
              Image.network(item),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        );
      }
    }

    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 900,
          color: Colors.white,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: EdgeInsets.fromLTRB(40, 20, 0, 0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    '카테고리',
                    style: TextStyle(fontSize: 24),
                  ),
                  Text('${user.category}', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  Text('가게이름', style: TextStyle(fontSize: 24)),
                  Text('${user.store_name}', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  Text('현재 운영 여부', style: TextStyle(fontSize: 24)),
                  Text('${user.store_open_info}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  Text('가게 정보', style: TextStyle(fontSize: 24)),
                  Text('${user.store_description}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  Text('메뉴 정보', style: TextStyle(fontSize: 24)),
                  Text('${user.menu_info}', style: TextStyle(fontSize: 18)),
                  SizedBox(
                    height: 30,
                  ),
                  Text('가게 사진', style: TextStyle(fontSize: 24)),
                  Text('${user.store_photo}', style: TextStyle(fontSize: 18)),
                  Container(
                    // 가게 사진 보여주는 부분
                    child: Row(
                      children: _storeImageWidgetList,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  JavascriptChannel _markerClicked(BuildContext context) {
    return JavascriptChannel(
        name: 'taeHyeonTV',
        onMessageReceived: (JavascriptMessage message) {
          showStoreInfo(message);
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
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('문어빵'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('츄러스'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('호떡'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('크레페'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('돈가스'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('아이스크림'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('닭꼬치'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('떡볶이'),
              onTap: () {
                _selectedIndex = 1;
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('순대'),
              onTap: () {
                _selectedIndex = 1;
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
            javascriptChannels: <JavascriptChannel>{
              _markerClicked(context),
            },
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String url) {
              _getNowLocation();
            },
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
