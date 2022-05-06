import 'package:flutter/material.dart';
import 'boong_main.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '영업 종료하기',
      home: boong_close(),
    );
  }
}

class boong_close extends StatefulWidget {
  boong_closeState createState() => boong_closeState();
}

class boong_closeState extends State<boong_close> {
  bool isTrue = true;

  void _closing(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('영업 종료'),
            content: const Text('영업을 종료하시겠습니까?'),
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
                                boong_main()));
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
        title: Text("영업 중..."),
        backgroundColor: Colors.black26,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 50.0,),
            Container(margin: EdgeInsets.all(8.0),),
            ElevatedButton(onPressed:isTrue == true ? () => _closing(context) : null,
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      TextStyle(fontSize: 40, color: Colors.white)),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.black45),
                ),
                child: Text("영업종료")),
          ],
        ),
      )
    );
  }
}
