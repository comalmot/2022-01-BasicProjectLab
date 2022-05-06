import 'dart:async';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'boong_timeEdit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '내 가게 정보',
      home: infoEdit(),
    );
  }
}

class infoEdit extends StatefulWidget {
  @override
  infoEditState createState() => infoEditState();
}

class infoEditState extends State<infoEdit> {
  String name = "";
  List<String> entries = <String>["HelloWorld!"];
  List<String> pictures = <String>['a.jpg','b.jpg','c.jpg','d.jpg']; // 임시 사진 업로드 체크용 사진. 이후 사진 수정 예정
  List<String> menu = <String>[""];
  int a =0;

  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("어서오세요!"),
        backgroundColor: Colors.black26,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("내 가게 정보",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
              Container(width: 100,
                child: Divider(color: Colors.black, thickness: 2.0),),
              Text("이름(10자 이하)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Container(margin: EdgeInsets.all(10.0), child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
              ),
              Text("점포명",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Container(margin: EdgeInsets.all(10.0), child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
              ),
              Text("카테고리 설정",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Container(margin: EdgeInsets.all(10.0), child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
              ),
              Container(child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text("가게 설명",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),
                  Container(width: 100,
                    child: Divider(color: Colors.black, thickness: 1.0),),
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
                  Container(margin: EdgeInsets.all(8.0),),
                  Text("영업시간",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: entries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height : 50,
                          color: Colors.black26,
                          child: Center(child: Text('${entries[index]}'),)
                      );
                    }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        entries.add("Hello World!"); //ListView 사용 임시 확인용 코드. 수정 필요
                      });
                    },
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 20, color: Colors.white)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey)),
                    child: Text("+"),),
                  Container(margin: EdgeInsets.all(8.0),),

                  Text("가게 사진 (" +'$a' +"/99)",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),

                  Container(
                    padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                    child: Row(
                      children: [Flexible(child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: a,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.black26,
                            child: Center(child: Image(image: AssetImage('assets/images/${pictures[index]}'),), // 사진 업로드 체크용. 이후 갤러리 열어서 사진 넘기는 쪽으로 수정 예정
                            ),
                          );
                        },
                      ),)],
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if(a >= pictures.length) { //임시.
                        }
                        else {
                          a++;
                        }
                      });
                    },
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 20, color: Colors.white)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey)),
                    child: Text("+"),),

                  Text("메뉴명/가격",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: menu.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height : 50,
                          color: Colors.black26,
                          child: Center(child: Text('${menu[index]}'),)
                      );
                    }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                  ElevatedButton( // 이후 화면 구성 후 처리 예정
                    onPressed: () {},
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 20, color: Colors.white)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey)),
                    child: Text("+"),),


                ],
              )),
              Container(margin: EdgeInsets.all(10.0),),
              Container(
                margin: EdgeInsets.fromLTRB(0, 70, 0, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                color: Colors.black26,
                child : Center(
                  child: ElevatedButton( //미입력된 부분 존재시 넘어가지 못하게 하는 부분 처리 x
                    onPressed: () {},
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 20, color: Colors.white)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey)),
                    child: Text("입력 완료", style: TextStyle(fontSize: 30, color: Colors.black, fontWeight: FontWeight.bold),),),
                ),
              )


            ],
          ),
        ),
      ),

    );
  }
}

