import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '검색',
      home: searchStore(),
    );
  }
}

class searchStore extends StatefulWidget {
  @override
  searchStoreState createState() => searchStoreState();
}

class searchStoreState extends State<searchStore> {
  final TextEditingController _textController = TextEditingController();
  String search = "";
  List<String> storeName = [];
  List<String> storeLocation = [];
  List<String> storeDistance = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          //title: Text("검색하기"),
          backgroundColor: Colors.black26,
        ),
        body: Container(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 305,
                        height: 50,
                        margin: const EdgeInsets.fromLTRB(0, 0, 7, 10),
                        child: TextField(
                          controller: _textController,
                          decoration: const InputDecoration(
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
                              hintText: "검색어를 입력하세요."),
                        ),
                      ),
                      Container(
                          width: 60,
                          height: 50,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () {
                                  storeName.clear();
                                  storeLocation.clear();
                                  storeDistance.clear();
                                  storeName.add("소봉타코");
                                  storeLocation.add("유성구 어은동 한빛아파트 앞");
                                  storeDistance.add("0.4 km");
                                  storeName.add("타코머코");
                                  storeLocation.add("유성구 노은동 노은역 앞");
                                  storeDistance.add("2.3 km");
                                  storeName.add("애기타코");
                                  storeLocation.add("유성구 도안동 센트럴정류장 앞");
                                  storeDistance.add("3.4 km");
                                  // 화면 새로고침
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => searchStore()),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black26,
                                    fixedSize: Size.fromHeight(50)),
                                child: const Text(
                                  '검색',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 15),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    itemCount: storeName.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            // border: Border.all(color: Colors.black26),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                  child: Text(
                                    storeName[index],
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 30),
                                  ),
                                ),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                          // alignment: Alignment.bottomLeft,
                                          child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 15, 0, 0),
                                        child: Text(
                                          storeLocation[index],
                                          textAlign: TextAlign.left,
                                        ),
                                      )),
                                      Align(
                                          // alignment: Alignment.bottomRight,
                                          child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 15, 10, 0),
                                        child: Text(
                                          storeDistance[index],
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20),
                                        ),
                                      ))
                                    ])
                              ]));
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ],
              ),
            )));
  }
}
