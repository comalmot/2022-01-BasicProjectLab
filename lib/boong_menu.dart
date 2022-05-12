import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'boong_infoEdit.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '메뉴 수정',
      home: boong_menu(),
    );
  }
}

class boong_menu extends StatefulWidget {
  boong_menuState createState() => boong_menuState();
}

class boong_menuState extends State<boong_menu> {
  List<File> images = <File>[];

  void _setImage() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    var userImage;
    if(image != null) {
      setState(() {
        userImage = File(image.path);
        images.add(userImage);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("메뉴 수정"),
          backgroundColor: Colors.black26,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    child:Column(
                      children: [
                        const Text('메뉴 수정', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                        Container(width: 100, child: const Divider(color: Colors.black, thickness: 1.0)),
                      ],
                    )
                ),
                Container(margin: EdgeInsets.all(10.0),),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    child:Column(
                      children: [
                        const Text('음식명', style: TextStyle(fontSize: 20,),),
                      ],
                    )
                ),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    child:Column(
                      children: [
                        TextField()
                      ],
                    )
                ),
                Container(margin: EdgeInsets.all(10.0),),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    child:Column(
                      children: [
                        const Text('음식 가격', style: TextStyle(fontSize: 20,),),
                      ],
                    )
                ),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    child:Column(
                      children: [
                        TextField()
                      ],
                    )
                ),
                Container(margin: EdgeInsets.all(10.0),),
                Container(
                    alignment: Alignment(-1.0, 0.0),
                    child:Column(
                      children: [
                        const Text('음식 사진', style: TextStyle(fontSize: 20,),),
                      ],
                    )
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                  child: Row(
                    children: [Flexible(child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          color: Colors.black26,
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
                Container(margin: EdgeInsets.all(20.0),),
                Container(
                  width: 1000,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {Navigator.pop(context);},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(width: 1.0, color: Colors.black),
                        ),
                        child: Text("완료", style: TextStyle(color: Colors.black, fontSize: 19), ),),
                    ],
                  ),
                )

              ],
            ),
          ),
        )
    );
  }
}
