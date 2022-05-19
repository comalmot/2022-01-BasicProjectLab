import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:our_town_boongsaegwon/boong_join.dart';
import 'boong_main.dart';
import 'boong_join.dart';
import 'customer_main.dart';

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
    return WillPopScope(child: Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
        backgroundColor: Colors.black26,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                '시작하기',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
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
                decoration: InputDecoration(
                    labelText: '아이디',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.grey),
                    ),
                    hintText: "아이디"),
              ),
              Container(
                margin: EdgeInsets.all(8.0),
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    labelText: '비밀번호',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(width: 1, color: Colors.grey),
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => boong_main()));
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
                          builder: (BuildContext context) => customer_main()));
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
    ), onWillPop: () {
      return _onBackPressed();
    });
  }
}
