import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: '우리동네 붕세권'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(
                  '시작하기',
                  style: TextStyle(fontSize: 38.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 150.0,
                  height: 2.0,
                  child: Container(
                    color: Colors.black,
                  ),
                ),
              ],
            ), // 시작하기 텍스트와 실선
            SizedBox(
              height: 36.0,
            ),
            Column(
              children: <Widget>[
                Text(
                  '사장님이신가요?',
                  style: TextStyle(
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(
                  height: 36.0,
                ),
                Container(
                    alignment: Alignment.center,
                    width: 400.0,
                    height: 200.0,
                    color: Colors.amberAccent,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 36.0,
                        ),
                        Container(
                            width: 350.0,
                            child: Column(
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '아이디',
                                  ),
                                ),
                                SizedBox(
                                  height: 18.0,
                                ),
                                TextField(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: '비밀번호',
                                  ),
                                  obscureText: true,
                                ),
                              ],
                            ))
                      ],
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
