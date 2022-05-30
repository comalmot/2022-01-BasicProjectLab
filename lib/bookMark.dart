import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '즐겨찾기',
      home: bookMark(),
    );
  }

}

class bookMark extends StatefulWidget {
  @override
  bookMarkState createState() => bookMarkState();
}

class bookMarkState extends State<bookMark> {
  List<String> name = ["대왕 닭꼬치", "씨앗 호떡집", "타코타코야끼", "우빈분식"];
  List<String> location = ["대전 유성구 어은동 한빛아파트 후문", "대전 유성구 궁동 로데오사거리", "대전 유성구 카이스트 서문 앞", "대전 서구 만년동 만년초등학교 정문 앞"];
  List<String> distance = ["1.0 km", "1.5 km", "3.1 lm", "4.3 km"];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("즐겨찾기"),
        backgroundColor: Colors.black26,
        ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListView.separated(
                shrinkWrap: true,
                itemCount: name.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        // border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text(name[index], style: TextStyle(color: Colors.black, fontSize: 30),)
                                ),
                                Container(
                                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    child: Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 30,
                                    )
                                )
                              ],

                            ),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                            //   child: Text(name[index], style: TextStyle(color: Colors.black, fontSize: 30),),
                            // ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                                    child: Text(location[index], textAlign: TextAlign.left,),),
                                  Container(
                                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 0),
                                    child: Text(distance[index], textAlign: TextAlign.right, style: TextStyle(color: Colors.black, fontSize: 20),),)
                                ]
                            )
                          ]
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
              ),
            ],
          ),
        ),
      ),
    );

  }

}

