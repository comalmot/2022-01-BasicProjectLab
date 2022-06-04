// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:our_town_boongsaegwon/searchStore.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'boong_infoEdit.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'bookMark.dart';

void main() => runApp(MyApp());

class storeInfo {
  String category = "";
  String? error;
  List<dynamic>? menu_info;
  String name = "";
  bool ok = false;
  String? store_description;
  String store_name = "";
  List<dynamic>? store_open_info;
  List<dynamic>? store_photo;

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
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      controller!.runJavascript(
          //'setMarker(${position.latitude},${position.longitude})'
          'setinitMap(${position.latitude},${position.longitude});getAllLocations();');
    }

    //controller!
    //    .runJavascript('setinitMap(36.366522, 127.344574);getAllLocations();');
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
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => bookMark()));
    // showModalBottomSheet<void>(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return Container(
    //       height: 700,
    //       color: Colors.amber,
    //       child: Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           mainAxisSize: MainAxisSize.min,
    //           children: <Widget>[
    //             const Text('Modal BottomSheet'),
    //             ElevatedButton(
    //                 child: const Text('Close BottomSheet'),
    //                 onPressed: () {
    //                   _selectedIndex = 1;
    //                   Navigator.pop(context);
    //                 })
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
/*
  Widget buildMyImage(BuildContext context, List<Widget>? Images) {
    return Container(
      height: 900,
      child: Images,
    );
  }
*/

  Widget buildMyMenu(BuildContext context, List<dynamic>? Menus) {
    List<Widget> myMenuList = [];
    if (Menus != null) {
      for (var item in Menus) {
        if (item['photo'] != null) {
          // Photo가 있는 경우
          myMenuList.add(Container(
            //height: 600,
            child: Column(
              children: <Widget>[
                Text(item['name'] + "\n"), // 메뉴 이름
                Text(item['price'].toString() + "\n"), // 메뉴 가격
                ClipRect(
                  child: Container(
                    child: Align(
                      alignment: Alignment.center,
                      widthFactor: 0.5,
                      heightFactor: 0.5,
                      child: Image.network(item['photo'].toString()),
                    ),
                  ),
                ),

                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ));
        } else {
          myMenuList.add(Container(
            //height: 600,
            child: Column(
              children: <Widget>[
                Text(item['name'] + "\n"), // 메뉴 이름
                Text(item['price'].toString() + "\n"), // 메뉴 가격
                Text("메뉴 사진 없음" + "\n"),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ));
        }
      }
      return Container(
        //height: 1200,
        child: Column(
          children: myMenuList,
        ),
      );
    }

    return Container(
      child: Text("메뉴 정보를 불러오지 못했습니다."),
    );
  }

  Widget buildmyStoreInfo(List<dynamic>? storeinfo) {
    List<Widget> myStoreInfoList = [];

    if (storeinfo != null) {
      for (var item in storeinfo) {
        myStoreInfoList.add(
          Column(
            children: <Widget>[
              Text("${item.toString().split(" ")[0] + ", " + item.toString().split(" ")[1] + ", " + item.toString().split(" ")[2]}",
                    style: TextStyle(fontSize: 14, fontFamily: 'NanumLarge'),),
              //Text("${item}"),   //에러 발생시 해당 줄 주석 사용 및 윗줄 주석 달기
              SizedBox(
                height: 30,
              )
            ],
          ),
        );
      }
      return Column(
        children: myStoreInfoList,
      );
    } else {
      return Text("가게 정보 불러오기 실패! 관리자에게 문의하세요.");
    }
  }

  showStoreInfo(JavascriptMessage jsMessage) {
    Map<String, dynamic> responseMap = jsonDecode(jsMessage.message);
    var user = storeInfo.fromJson(responseMap);
    List<Widget> _storeImageWidgetList = [];
    List<dynamic> Menus = [];
    var store_Photos = user.store_photo;
    Menus = user.menu_info!;

    if (store_Photos != null) {
      for (var item in store_Photos) {
        if (item.toString().contains("http")) {
          _storeImageWidgetList.add(
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
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NanumLarge'),
                  ),
                  Text('${user.category}', style: TextStyle(fontSize: 18, fontFamily: 'NanumRegular')),
                  SizedBox(
                    height: 30,
                  ),
                  Text('가게이름', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NanumLarge')),
                  Text('${user.store_name}', style: TextStyle(fontSize: 18, fontFamily: 'NanumLarge')),
                  SizedBox(
                    height: 30,
                  ),
                  Text('현재 운영 여부 및 운영 시간', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NanumLarge')),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: buildmyStoreInfo(user.store_open_info),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('가게 정보', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NanumLarge')),
                  Text('${user.store_description}',
                      style: TextStyle(fontSize: 18, fontFamily: 'NanumLarge')),
                  SizedBox(
                    height: 30,
                  ),
                  Text('메뉴 정보', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NanumLarge')),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    child: buildMyMenu(context, Menus),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text('가게 사진', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'NanumLarge')),
                  SizedBox(
                    height: 30,
                  ),
                  ClipRect(
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        widthFactor: 0.5,
                        heightFactor: 0.5,
                        child: Column(
                          children: _storeImageWidgetList,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  //Text('${user.store_photo}', style: TextStyle(fontSize: 18)),
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
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
             Container(margin: EdgeInsets.fromLTRB(0, 65, 0, 0),),
              Container(
                //padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 290,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 0, 7, 10),
                      child: TextField(
                        decoration: const InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.black),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                              borderSide:
                              BorderSide(width: 1, color: Colors.grey),
                            ),
                            hintText: "검색어를 입력하세요."),
                      ),
                    ),
                    Container(
                        width: 60,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              searchStore("타코")));
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black26,
                                    fixedSize: Size.fromHeight(50)),
                                child: Icon(
                                  Icons.search,
                                  size: 30.0,
                                ))
                          ],
                        )),
                  ],
                ),
              ),
              Container(
                height: 590,
                child: Container(
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
              ),
            ],
          ),

        ),
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
