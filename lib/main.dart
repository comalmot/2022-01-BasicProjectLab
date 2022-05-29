import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_town_boongsaegwon/boong_join.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';
import 'dart:convert';
import 'boong_main.dart';
import 'boong_join.dart';
import 'customer_main.dart';
import 'package:get/get.dart';
import 'token_controller.dart';

class login {
  String? error;
  bool? ok;
  String? token;

  login({this.error, this.ok, this.token});

  login.fromJson(Map<String, dynamic> json) {
    this.error = json['error'];
    this.ok = json['ok'];
    this.token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['ok'] = this.ok;
    data['token'] = this.token;
    return data;
  }
}

class Arguments {}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '로그인',
      home: MyEditText(),
    );
  }
}

class MyEditText extends StatefulWidget {
  @override
  MyEditTextState createState() => MyEditTextState();
}

class MyEditTextState extends State<MyEditText> {
  final TextEditingController controller = TextEditingController();

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
    final _idTextController = TextEditingController();
    final _pwTextController = TextEditingController();
    final _loginFormKey = GlobalKey<FormState>();
    late Future<login> _loginfutureAlbum;
    GlobalKey<ScaffoldState> _loginSnackBar = GlobalKey();

    final TokenController =
        Get.put(token_controller()); // GetX를 활용해 Token 상태관리.

    Future<login> fetchLogin(String id, String pwd) async {
      final msg = jsonEncode({"id": id, "password": pwd});
      final response =
          await http.post(Uri.parse('http://boongsaegwon.kro.kr/login'),
              headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
              },
              body: msg);

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        if (login.fromJson(json.decode(response.body)).ok == true) {
          final _loginSnackBar = SnackBar(
            content: Text("로그인 성공."),
          );

          ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);

          TokenController.updateToken(
              login.fromJson(json.decode(response.body)).token.toString());

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => boong_main(
                      login
                          .fromJson(json.decode(response.body))
                          .token
                          .toString(),
                      id)));
        }
        return login.fromJson(json.decode(response.body));
      } else {
        final _loginSnackBar = SnackBar(
          content: Text("로그인 실패."),
        );

        ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);
        throw Exception('Error : Failed to login');
      }
    }

    @override
    void dispose() {
      // Clean up Controller
      _idTextController.dispose();
      _pwTextController.dispose();
      super.dispose();
    }

    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("로그인"),
            backgroundColor: Colors.black26,
          ),
          body: Form(
            key: _loginFormKey,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      '시작하기',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Container(
                        width: 100,
                        child: Divider(color: Colors.black, thickness: 1.0)),
                    Row(
                      children: [
                        Text(
                          '사장님 안녕하세요!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                    ),
                    TextField(
                      controller: _idTextController,
                      decoration: InputDecoration(
                          labelText: '아이디',
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
                          hintText: "아이디"),
                    ),
                    Container(
                      margin: EdgeInsets.all(8.0),
                    ),
                    TextField(
                      controller: _pwTextController,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: '비밀번호',
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
                          hintText: "비밀번호"),
                    ),
                    Container(
                      margin: EdgeInsets.all(4.0),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        makeProfile()));
                          },
                          style: ButtonStyle(
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 20, color: Colors.white)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.black45)),
                          child: Text("회원가입"),
                        ),
                        Container(
                          margin: EdgeInsets.all(8.0),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // if Login is successed, go to boong_main()
                            //

                            if (_loginFormKey.currentState!.validate()) {
                              _loginFormKey.currentState!.save();
                              _loginfutureAlbum = fetchLogin(
                                  _idTextController.text,
                                  _pwTextController.text);
                              FutureBuilder<login>(
                                future: _loginfutureAlbum,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (snapshot.data?.ok == true) {
                                    } else {}
                                  } else if (snapshot.hasError) {}
                                  return CircularProgressIndicator();
                                },
                              );
                            }
                          },
                          style: ButtonStyle(
                              textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 20, color: Colors.white)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.grey)),
                          child: Text("로그인"),
                        )
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(2.0),
                    ),
                    Container(
                        width: 100,
                        child: Divider(color: Colors.black, thickness: 1.0)),
                    Text(
                      '손님이시라면?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(2.0),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    customer_main()));
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(width: 1.0, color: Colors.black),
                      ),
                      child: Text(
                        "손님으로 시작하기",
                        style: TextStyle(color: Colors.black, fontSize: 19),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () {
          return _onBackPressed();
        });
  }
}
