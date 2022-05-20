import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'boong_menuEdit.dart';
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
  static List<String> entries = <String>[];
  static List<String> menus = <String>[""];
  static List<File> images = <File>[];
  int a =0;


  void _setImage() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    var userImage;
    if(image != null) {
      setState(() {
        userImage = File(image.path);
        images.add(userImage);
        a++;
      });
    }
  }

  final TextEditingController controller = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("가게 정보 수정"),
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
              Text("가게 사진 (" +'$a' +"/99)",
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),),

              Container(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: Row(
                  children: [Flexible(child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: images.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.grey,
                        child: Center(child: Image(image: FileImage(images[index]),), // 사진 업로드 체크용. 이후 갤러리 열어서 사진 넘기는 쪽으로 수정 예정
                        ),
                      );
                    },
                  ),)],
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
                    backgroundColor:
                    MaterialStateProperty.all(Colors.grey)),
                child: Text("+"),),

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
                          child: Center(child: Text(entries[index]),)
                      );
                    }, separatorBuilder: (BuildContext context, int index) => const Divider(),
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
                      }
                    },
                    // {
                    //   setState(() {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder:
                    //                 (BuildContext context) =>
                    //                 timeEdit())); //ListView 사용 임시 확인용 코드. 수정 필요
                    //   });
                    // },
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 20, color: Colors.white)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey)),
                    child: Text("+"),),
                  Container(margin: EdgeInsets.all(8.0),),

                  Text("메뉴명/가격",
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: menus.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height : 50,
                          color: Colors.black26,
                          child: Center(child: Text('${menus[index]}'),)
                      );
                    }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                  ElevatedButton( // 이후 화면 구성 후 처리 예정
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder:
                                  (BuildContext context) =>
                                  menuEdit()));
                    },
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
                    onPressed: () {Navigator.pop(context);},
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

