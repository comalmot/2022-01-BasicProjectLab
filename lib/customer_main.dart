import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'boong_infoEdit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '영업일시 및 장소 수정',
      home: customer_main(),
    );
  }
}

class customer_main extends StatefulWidget {
  @override
  customer_mainState createState() => customer_mainState();
}

class customer_mainState extends State<customer_main> {
  String url = ""; // 띄울 웹 페이지의 주소
  Set<JavascriptChannel>? channel;
  WebViewController? controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
        ),
        body: SafeArea(
            child: WebView(
          initialUrl: "http://google.com",
          onWebViewCreated: (controller) {
            this.controller = controller;
          },
          javascriptChannels: channel,
          javascriptMode: JavascriptMode.unrestricted,
        )));
  }
}
