import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'boong_infoEdit.dart';
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'token_controller.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '메뉴 수정',
      home: menuEdit(),
    );
  }
}

class menuEdit extends StatefulWidget {
  //final String token;
  //final String id;

  //@override
  //const menuEditthis.token, this.id);
  menuEditState createState() => menuEditState();
}

class menuEditState extends State<menuEdit> {
  static List<File> images = <File>[];
  final formKey = GlobalKey<FormState>();
  String _menu = '';
  String _price = '';
  static List<dynamic> returnData = [];
  String ret_enc_images = "";

  Map<String, dynamic> retData = {};

  void _setImage() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    var userImage;
    if (image != null) {
      setState(() {
        userImage = File(image.path);
        images.add(userImage);

        // 이미지 base64 인코딩
        final bytes = userImage.readAsBytesSync();
        ret_enc_images = base64Encode(bytes);
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
        body: Form(
            key: formKey,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        alignment: Alignment(-1.0, 0.0),
                        child: Column(
                          children: [
                            const Text(
                              '메뉴 수정',
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                    Container(
                      width: 1000,
                      child: Divider(color: Colors.black, thickness: 2.0),
                    ),
                    Container(
                      margin: EdgeInsets.all(10.0),
                    ),
                    Container(
                        alignment: Alignment(-1.0, 0.0),
                        child: Column(
                          children: [
                            const Text(
                              '음식명',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        alignment: Alignment(-1.0, 0.0),
                        child: Column(
                          children: [
                            TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              decoration: const InputDecoration(
                                hintText: 'ex) 타코야끼(8알) ',
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _menu = value as String;
                                });
                              },
                            )
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.all(10.0),
                    ),
                    Container(
                        alignment: Alignment(-1.0, 0.0),
                        child: Column(
                          children: [
                            const Text(
                              '음식 가격',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )),
                    Container(
                        alignment: Alignment(-1.0, 0.0),
                        child: Column(
                          children: [
                            TextFormField(
                              autovalidateMode: AutovalidateMode.always,
                              decoration: const InputDecoration(
                                hintText: 'ex) 3000원 ',
                              ),
                              onSaved: (value) {
                                setState(() {
                                  _price = value as String;
                                });
                              },
                            )
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.all(10.0),
                    ),
                    Container(
                        alignment: Alignment(-1.0, 0.0),
                        child: Column(
                          children: [
                            const Text(
                              '음식 사진',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        )),
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
                                  color: Colors.black26,
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
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey)),
                      child: Text("+"),
                    ),
                    Container(
                      margin: EdgeInsets.all(20.0),
                    ),
                    Container(
                      width: 1000,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          OutlinedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                formKey.currentState!.save();

                                //returnData.add(_menu + "     " + _price);
                                // returnData.add(images);

                                retData['name'] = _menu;
                                retData['price'] = _price;
                                retData['photo'] = ret_enc_images;

                                Navigator.pop(context, retData);
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(width: 1.0, color: Colors.black),
                            ),
                            child: Text(
                              "완료",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 19),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }
}
