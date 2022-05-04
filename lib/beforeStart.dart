import 'package:flutter/material.dart';
import 'main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '환영합니다!',
      home: beforeStart(),
    );
  }
}

class beforeStart extends StatefulWidget {
  @override
  beforeStartState createState() => beforeStartState();
}

class beforeStartState extends State<beforeStart> {

  final TextEditingController controller = TextEditingController();
  String name = "name";
  bool isTrue = true;

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
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (BuildContext context) =>
                                MyEditText()));
                  },
                  child: const Text('Yes', style: TextStyle(fontSize: 20),)),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('No', style: TextStyle(fontSize: 20),))
            ],
          );
        });
  }

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
              Text('$name' + ' 님 안녕하세요!', textAlign: TextAlign.center, style: TextStyle(fontSize: 30),),
              Container(margin: EdgeInsets.all(8.0),),
              ElevatedButton(onPressed: () {},
                  style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 40, color: Colors.white)),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.black45),
                  ),
                  child: Text("영업 시작")),
              Container(margin: EdgeInsets.all(15.0),),
              ElevatedButton(onPressed: () {},
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                        TextStyle(fontSize: 40, color: Colors.white)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.black45),
                  ),
                  child: Text("가게 정보 수정")),
              Container(margin: EdgeInsets.all(15.0),),
              ElevatedButton(onPressed:isTrue == true ? () => _delete(context) : null,
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
    );
  }
}