import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_town_boongsaegwon/boong_main.dart';
import 'package:our_town_boongsaegwon/boong_timeEdit.dart';
import 'boong_menu.dart';
import 'dart:io';
import'main.dart';
import 'boong_time.dart';
import 'boong_timeEdit.dart';
import 'boong_menuEdit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '내 가게 정보',
      home: info(),
    );
  }
}

class info extends StatefulWidget {
  @override
  infoState createState() => infoState();
}

class infoState extends State<info> {
  String name = "";
  static List<String> entries = <String>[];
  static List<String> menus = <String>[];
  List<File> images = <File>[];
  int a = 0;

  void _setImage() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    var userImage;
    if (image != null) {
      setState(() {
        userImage = File(image.path);
        images.add(userImage);
        a++;
      });
    }
  }
  Future<bool> _onBack() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("가입을 종료하시겠습니까?"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                MyEditText()));
                  },
                  child: Text("네")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text("아니오")),
            ],
          );
        });
  }

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("가게 정보 입력"),
        backgroundColor: Colors.black26,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                "내 가게 정보",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 100,
                child: Divider(color: Colors.black, thickness: 2.0),
              ),
              Text(
                "이름(10자 이하)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                  ),
                ),
              ),
              Text(
                "점포명",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                  ),
                ),
              ),
              Text(
                "카테고리 설정",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                  ),
                ),
              ),
              Text(
                "가게 설명",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 100,
                child: Divider(color: Colors.black, thickness: 1.0),
              ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                minLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
              Container(margin: EdgeInsets.all(10.0)),
              Text(
                "영업시간 및 장소",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              ListView.separated(
                shrinkWrap: true,
                itemCount: entries.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 50,
                      color: Colors.black26,
                      child: Center(
                        child: Text('${entries[index]}'),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
              ElevatedButton(
                onPressed: () async {
                  final returnData = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => timeEdit()
                      )
                  );
                  if( returnData != null ){
                    int i = timeEditState.returnData.length;
                    entries.add(timeEditState.returnData[i-1]);

                    print("modified: $returnData");
                    print("modified: $entries");
                    // 화면 새로고침
                    Navigator. pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => info()),
                          (Route<dynamic> route) => false,
                    );
                  }
                },

                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 20, color: Colors.white)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.grey)),
                child: Text("+"),
              ),
              Container(margin: EdgeInsets.all(10.0)),
              Text(
                "가게 사진 (" + '$a' + "/99)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: Row(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.grey,
                            child: Center(
                              child: Image(
                                image: FileImage(images[index]),
                              ), // 사진 업로드 체크용. 이후 갤러리 열어서 사진 넘기는 쪽으로 수정 예정
                            ),
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _setImage();
                  });
                },
                style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 20, color: Colors.white)),
                    backgroundColor: MaterialStateProperty.all(Colors.grey)),
                child: Text("+"),
              ),
              Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8.0),
                      ),

                      Container(
                        margin: EdgeInsets.all(8.0),
                      ),
                      Text(
                        "메뉴명/가격",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: menus.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              height: 50,
                              color: Colors.black26,
                              child: Center(
                                child: Text('${menus[index]}'),
                              ));
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                      ),
                      ElevatedButton( // 이후 화면 구성 후 처리 예정
                        onPressed: () async {
                          final returnData = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => menuEdit()
                              )
                          );
                          if( returnData != null ){
                            int i = menuEditState.returnData.length;
                            menus.add(menuEditState.returnData[i-1]);

                            print("modified: $returnData");
                            // 화면 새로고침
                            Navigator. pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => info()),
                                  (Route<dynamic> route) => false,
                            );
                          }
                        },
                        style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                                TextStyle(fontSize: 20, color: Colors.white)),
                            backgroundColor:
                            MaterialStateProperty.all(Colors.grey)),
                        child: Text("+"),),
                    ],
                  )),
              Container(
                margin: EdgeInsets.all(10.0),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Colors.black26,
                child: Center(
                  child: ElevatedButton(
                    //미입력된 부분 존재시 넘어가지 못하게 하는 부분 처리 x
                    onPressed: () {Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                boong_main()));},
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 20, color: Colors.white)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey)),
                    child: Text(
                      "입력 완료",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ), onWillPop: () {
      return _onBack();
    });
  }
}
