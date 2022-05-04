import 'package:flutter/material.dart';

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
  List<String> entries = <String>["HelloWorld!"];
  int a =0;

  final TextEditingController controller = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              Text("이름(10자 이하)",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Container(margin: EdgeInsets.all(10.0), child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
              ),
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
              Text("카테고리 설정",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              Container(margin: EdgeInsets.all(10.0), child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                  ),
                ),
              ),
              ),
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
                          child: Center(child: Text('${entries[index]}'),)
                      );
                    }, separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        entries.add("Hello World!"); //ListView 사용 임시 확인용 코드. 수정 필요
                      });
                    },
                    style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 20, color: Colors.white)),
                        backgroundColor:
                        MaterialStateProperty.all(Colors.grey)),
                    child: Text("+"),)

                ],
              )),



            ],
          ),
        ),
      ),
    );
  }
}