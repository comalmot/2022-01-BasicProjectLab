import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_town_boongsaegwon/boong_close.dart';
import 'package:our_town_boongsaegwon/boong_open.dart';
import 'main.dart';
import 'boong_infoEdit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '환영합니다!',
      home: boong_main("", ""),
    );
  }
}

class boong_main extends StatefulWidget {
  final String token;
  final String id;

  @override
  const boong_main(this.token, this.id);

  boong_mainState createState() => boong_mainState();
}

class logout {
  String? error;
  bool? ok;

  logout({this.error, this.ok});

  logout.fromJson(Map<String, dynamic> json) {
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

class boong_mainState extends State<boong_main> {
  final TextEditingController controller = TextEditingController();
  String name = "name";
  bool isTrue = true;

  Future<logout> fetchLogout(String id) async {
    final msg = jsonEncode({"id": id});
    final response =
        await http.post(Uri.parse('http://boongsaegwon.kro.kr/logout'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
            },
            body: msg);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      if (logout.fromJson(json.decode(response.body)).ok == true) {
        final _logoutSnackBar = SnackBar(
          content: Text("로그아웃 성공."),
        );

        ScaffoldMessenger.of(context).showSnackBar(_logoutSnackBar);

        Navigator.pop(context);
      }
      return logout.fromJson(json.decode(response.body));
    } else {
      final _logoutSnackBar = SnackBar(
        content: Text("로그아웃 실패."),
      );

      ScaffoldMessenger.of(context).showSnackBar(_logoutSnackBar);
      throw Exception('Error : Failed to logout');
    }
  }

  void _delete(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('로그아웃'),
            content: const Text('정말 로그아웃하시겠습니까?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      isTrue = false;
                    });
                    fetchLogout(widget.id);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => MyEditText()));
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 20),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          );
        });
  }

  Future<bool> _onBackPressed() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("끝내시겠습니까?"),
            actions: [
              TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("어서오세요!"),
          backgroundColor: Colors.black26,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  '$name' + ' 님 안녕하세요!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 30),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  boong_open(widget.token, widget.id)));
                    },
                    //원래 지도가 연결되어야 하는데 일단 영업종료 버튼 창이 나오도록 연결해놓움
                    // -> 2022.05.30 수정 완료.
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 40, color: Colors.white)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black45),
                    ),
                    child: Text("영업 시작")),
                Container(
                  margin: EdgeInsets.all(15.0),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => infoEdit(
                                  widget.token,
                                  widget.id,
                                  "",
                                  "",
                                  "",
                                  "",
                                  null)));
                    },
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 40, color: Colors.white)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black45),
                    ),
                    child: Text("가게 정보 수정")),
                Container(
                  margin: EdgeInsets.all(15.0),
                ),
                ElevatedButton(
                    onPressed: isTrue == true ? () => _delete(context) : null,
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 40, color: Colors.white)),
                      backgroundColor:
                          MaterialStateProperty.all(Colors.black45),
                    ),
                    child: Text("로그아웃")),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () {
        return _onBackPressed();
      },
    );
  }
}
