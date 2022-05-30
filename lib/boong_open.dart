import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:our_town_boongsaegwon/boong_close.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'boong_infoEdit.dart';
import 'package:bottom_drawer/bottom_drawer.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class LocationInfo {
  bool? ok;
  String? error;

  LocationInfo(
    this.error,
    this.ok,
  );

  LocationInfo.fromJson(Map<String, dynamic> json)
      : error = json['error'],
        ok = json['ok'];

  Map<String, dynamic> toJson() => {
        'error': error,
        'ok': ok,
      };
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '영업일시 및 장소 수정',
      home: boong_open("", ""),
    );
  }
}

class boong_open extends StatefulWidget {
  final String token;
  final String id;

  const boong_open(this.token, this.id);
  @override
  boong_mainState createState() => boong_mainState();
}

class boong_mainState extends State<boong_open> {
  String url = ""; // 띄울 웹 페이지의 주소

  WebViewController? controller;

  void _getNowLocation() async {
    /*
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      controller!.runJavascript(
          'setinitMap(${position.latitude},${position.longitude});setMarker(${position.latitude},${position.longitude})');
    }
    */

    controller!.runJavascript(
        'setinitMap(36.366522, 127.344574);setMarker(36.366522, 127.344574)');
  }

  @override
  Widget build(BuildContext context) {
    double ratio = MediaQuery.of(context).devicePixelRatio;

    Future<LocationInfo> fetchLogin(String id, double lat, double lng) async {
      final msg = jsonEncode(
          {"id": id, "latitude": lat, "longitude": lng, "is_open": true});
      final response =
          await http.post(Uri.parse('http://boongsaegwon.kro.kr/set_location'),
              headers: {
                'Content-Type': 'application/json; charset=UTF-8',
                HttpHeaders.authorizationHeader: widget.token,
              },
              body: msg);

      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.

        if (LocationInfo.fromJson(json.decode(response.body)).ok == true) {
          final _loginSnackBar = SnackBar(
            content: Text("영업 시작!"),
          );

          ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      boong_close(widget.token, widget.id)));
        }
        return LocationInfo.fromJson(json.decode(response.body));
      } else {
        final _loginSnackBar = SnackBar(
          content: Text("영업 시작 실패! 관리자에게 문의하세요."),
        );

        ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);
        throw Exception('Error : Failed to login');
      }
    }

    return Scaffold(
      body: SafeArea(
        child: ClipRect(
            child: Transform.scale(
          scale: ratio,
          child: WebView(
            initialUrl: "http://boongsaegwon.kro.kr",
            onWebViewCreated: (controller) {
              this.controller = controller;
            },
            javascriptMode: JavascriptMode.unrestricted,
            onPageFinished: (String url) {
              _getNowLocation();
            },
          ),
        )),
      ),
    );
  }
}
