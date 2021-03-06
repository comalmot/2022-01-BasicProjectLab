import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:our_town_boongsaegwon/boong_info.dart';
import 'package:our_town_boongsaegwon/boong_main.dart';
import 'package:our_town_boongsaegwon/customer_main.dart';
import 'boong_menuEdit.dart';
import 'dart:io';
import 'boong_timeEdit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io' as IO;
import 'package:get/get.dart';
import 'token_controller.dart';
import 'main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: '내 가게 정보',
      home: infoEdit("", ""),
    );
  }
}

// 기존 데이터를 불러온 뒤 저장하기 위한 전역변수.
GetStoreInfo? initStoreInfo;
Future<GetStoreInfo>? myFuture;

class SetStoreInfo {
  String? error;
  bool? ok;

  SetStoreInfo({this.error, this.ok});

  SetStoreInfo.fromJson(Map<String, dynamic> json) {
    this.error = json['error'];
    this.ok = json['ok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['ok'] = this.ok;
    return data;
  }
}

class GetStoreInfo {
  String category = "";
  String? error;
  List<dynamic>? menu_info;
  String name = "";
  bool ok = false;
  String? store_description;
  String store_name = "";
  List<dynamic>? store_open_info;
  List<dynamic>? store_photo;

  GetStoreInfo(
      this.category,
      this.error,
      this.menu_info,
      this.name,
      this.ok,
      this.store_description,
      this.store_name,
      this.store_open_info,
      this.store_photo);

  GetStoreInfo.fromJson(Map<String, dynamic> json)
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

class infoEdit extends StatefulWidget {
  final String token;
  final String id;
  // 2022.06.01 진건승.
  // 가게 이름, 가게 설명, 사진을 GetX로 하려다가, 이미 Routes가 GetX 기반으로 되어있지 않아 개발이 꼬일 것 같아서 GetX 사용 안함.
  //final List<File> saveState_menuImages;

  const infoEdit(
    this.token,
    this.id,
  );

  @override
  infoEditState createState() => infoEditState();
}

class storeCotroller extends GetxController {
  bool isNotFirst = false;
  String storeName = "";
  String category = "";
  List<File> image = <File>[];
  String storeInfo = "";
  List<String> storeTime = []; // for display
  List<Map<String, dynamic>> storeMenu = []; // for display
  List<String> storeImgs = [];

  int aa = 0;

  void categoryInfoAdd(String a) {
    category = a;
    update();
  }

  void storeNameAdd(String a) {
    storeName = a;
    update();
  }

  void storeInfoAdd(String a) {
    storeInfo = a;
    update();
  }

  void storeTimeAdd(List<String> a) {
    storeTime = a;
    update();
  }

  void storeMenuAdd(List<Map<String, dynamic>> a) {
    storeMenu = a;
    update();
  }

  void imageAdd(File a) {
    image.add(a);
    update();
  }

  List<File> images() {
    return image;
  }

  void plusA() {
    aa++;
    update();
  }

  void First() {
    isNotFirst = true;
    update();
  }
}

class infoEditState extends State<infoEdit> {
  String name = "";
  List<String> entries = <String>[];
  List<Map<String, dynamic>> menus = [];
  List<File> images = <File>[];
  List<String> enc_images = <String>[];
  String menuDataMove = "";
  int indexNUmber = 0;

  int a = 0;
  // 가게 이름, 가게 설명, 영업 시간, 메뉴명 및 가격에 접근하기 위한 컨트롤러 선언
  TextEditingController _Store_Name_Controller = TextEditingController();
  TextEditingController _Store_Desc_Controller = TextEditingController();
  TextEditingController _Store_Time_Controller = TextEditingController();
  TextEditingController _Store_Menu_Controller = TextEditingController();
  TextEditingController _Store_Cate_Controller = TextEditingController();
  final controller = Get.put(storeCotroller());

  @override
  void initState() {
    final con = Get.put(storeCotroller());
    super.initState();

    myFuture = fetchGetStoreInfo(widget.id);

    myFuture!.then((value) {
      setState(() {
        if (controller.isNotFirst == false) {
          List<String> StoreTimeArgs = [];

          for (var item in value.store_open_info!) {
            StoreTimeArgs.add("${item}");
          }

          List<Map<String, dynamic>> StoreMenuArgs = [];
          for (var item in value.menu_info!) {
            //StoreMenuArgs.add("메뉴명 : ${item['name']}  가격 : ${item['price']}원");
            StoreMenuArgs.add(item);
          }

          List<String> StoreImgArgs = [];
          for (var item in value.store_photo!) {
            controller.storeImgs.add(item);
          }
          controller.storeNameAdd(value.store_name);
          controller.storeInfoAdd(value.store_description!);
          controller.categoryInfoAdd(value.category);
          _Store_Name_Controller.text = controller.storeName;
          _Store_Cate_Controller.text = controller.category;
          _Store_Desc_Controller.text = controller.storeInfo;
          controller.storeTimeAdd(StoreTimeArgs);
          controller.storeMenuAdd(StoreMenuArgs);

          controller.First();
        }
      });
    });
  }

  void _setImage() async {
    var picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    var userImage;
    if (image != null) {
      setState(() {
        userImage = File(image.path);
        images.add(userImage);

        final con = Get.put(storeCotroller());
        con.imageAdd(userImage);

        // 이미지 base64 인코딩
        final bytes = userImage.readAsBytesSync();
        controller.storeImgs.add(base64Encode(bytes));

        con.plusA();
      });
    }
  }

  Future<GetStoreInfo> fetchGetStoreInfo(String id) async {
    final msg = jsonEncode({"id": id});
    final response =
        await http.post(Uri.parse('http://boongsaegwon.kro.kr/get_store_info'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
            },
            body: msg);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      if (GetStoreInfo.fromJson(json.decode(response.body)).ok == true) {
        final _logoutSnackBar = SnackBar(
          content: Text("가게 정보 로드 성공."),
        );

        ScaffoldMessenger.of(context).showSnackBar(_logoutSnackBar);

        initStoreInfo = GetStoreInfo.fromJson(json.decode(response.body));
      }
      return GetStoreInfo.fromJson(json.decode(response.body));
    } else {
      final _logoutSnackBar = SnackBar(
        content: Text("가게 정보 로드 실패."),
      );

      ScaffoldMessenger.of(context).showSnackBar(_logoutSnackBar);
      throw Exception('Error : Failed to logout');
    }
  }

  Future<SetStoreInfo> fetchSetStoreInfo(
      String id,
      String name, // 변경될 가게 이름..?
      String store_name,
      String category,
      String store_description,
      List<String> store_open_info,
      List<String> store_photo,
      List<Map<String, dynamic>> menu) async {
    Map<String, dynamic> requestBody = {
      'id': id,
      'name': name,
      'store_name': store_name,
      'category': category,
      'store_description': store_description,
      'store_open_info': {
        'information': store_open_info,
      },
      'store_photo': {
        'photo_urls': store_photo,
      },
      'menu_info': {
        'menu': menu,
      },
    };
    final msg = jsonEncode(requestBody);
    final response =
        await http.post(Uri.parse('http://boongsaegwon.kro.kr/set_store_info'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
            },
            body: msg);

    print(requestBody); // for Debug

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      if (SetStoreInfo.fromJson(json.decode(response.body)).ok == true) {
        final _loginSnackBar = SnackBar(
          content: Text("가게 정보 입력 완료."),
        );

        ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);
      }
      return SetStoreInfo.fromJson(json.decode(response.body));
    } else {

      final _loginSnackBar = SnackBar(
        content: Text(SetStoreInfo.fromJson(json.decode(response.body)).error! + " "),
      );

      ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);
      throw Exception('Error : Failed to login');
    }
  }

  @override
  Widget build(BuildContext context) {
    _Store_Name_Controller.text = controller.storeName;
    _Store_Cate_Controller.text = controller.category;
    _Store_Desc_Controller.text = controller.storeInfo;
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
              Text(
                "내 가게 정보",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Container(
                width: 100,
                child: Divider(color: Colors.black, thickness: 2.0),
              ),
              Text(
                "점포명",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      controller.storeNameAdd(_Store_Name_Controller.text);
                      //_Store_Name_Controller.text = controller.storeName;
                    });
                  },
                  onSubmitted: ((value) {
                    //widget.saveState_storeName = _Store_Name_Controller.text;
                  }),

                  controller: _Store_Name_Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                  ),
                ),
              ),
              Text(
                "카테고리",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      controller.categoryInfoAdd(_Store_Cate_Controller.text);
                    });
                  },
                  controller: _Store_Cate_Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6.0)),
                    ),
                  ),
                ),
              ),
              Text(
                "가게 사진 (" + '${controller.aa}' + "/99)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                child: Row(
                  children: [
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.images().length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            color: Colors.grey,
                            child: Center(
                              child: Image(
                                image: FileImage(controller.images()[index]),
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
                  Text(
                    "가게 설명",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 100,
                    child: Divider(color: Colors.black, thickness: 1.0),
                  ),
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        controller.storeInfoAdd(_Store_Desc_Controller.text);
                      });
                    },
                    controller: _Store_Desc_Controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                  ),
                  Text(
                    "영업시간",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.storeTime.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                            height: 50,
                            color: Colors.black26,
                            child: Center(
                              child: Text(controller.storeTime[index]),
                            )),
                        onTap: () {
                          menuDataMove = controller.storeTime[index] + " " + index.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                              builder: (BuildContext context) => timeEdit(menuDataMove)));
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final returnData = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => timeEdit("   ")));

                      if (returnData != null) {
                        int i = timeEditState.returnData.length;
                        controller.storeTime
                            .add(timeEditState.returnData[i - 1]);

                        print("modified: $returnData");
                        //print("modified: $entries");
                        // 화면 새로고침
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => infoEdit(
                                    widget.token,
                                    widget.id,
                                  )),
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
                  Container(
                    margin: EdgeInsets.all(8.0),
                  ),
                  const Text(
                    "메뉴명/가격",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: controller.storeMenu.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 50,
                          color: Colors.black26,
                          child: Center(
                            child: Text(
                                '메뉴 : ${controller.storeMenu[index]['name']} 가격 : ${controller.storeMenu[index]['price']}원'),
                          ));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                  ElevatedButton(
                    // 이후 화면 구성 후 처리 예정
                    onPressed: () async {
                      final returnData = await Navigator.push(context,
                          MaterialPageRoute(builder: (context) => menuEdit()));
                      if (returnData != null) {
                        int i = menuEditState.returnData.length;
                        print(returnData);

                        String MainMapKeyTemp = i.toString();
                        controller.storeMenu.add(returnData);

                        print("modified: $returnData");
                        // 화면 새로고침
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => infoEdit(
                                    widget.token,
                                    widget.id,
                                  )),
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
                    onPressed: () {
                      fetchSetStoreInfo(
                          widget.id,
                          name,
                          _Store_Name_Controller.text,
                          _Store_Cate_Controller.text,
                          _Store_Desc_Controller.text,
                          controller.storeTime,
                          controller.storeImgs,
                          controller.storeMenu);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  boong_main(widget.token, widget.id)));
                    },
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
    );
  }
}
