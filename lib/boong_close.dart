import 'package:flutter/material.dart';
import 'boong_main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '영업 종료하기',
      home: boong_close("", "", 0.0, 0.0),
    );
  }
}

class boong_close extends StatefulWidget {
  final String token;
  final String id;
  final double lat;
  final double lng;
  const boong_close(this.token, this.id, this.lat, this.lng);
  boong_closeState createState() => boong_closeState();
}

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

class boong_closeState extends State<boong_close> {
  bool isTrue = true;

  Future<LocationInfo> fetchLocation(String id, double lat, double lng) async {
    final msg = jsonEncode(
        {"id": id, "latitude": lat, "longitude": lng, "is_open": false});
    final response =
        await http.post(Uri.parse('http://boongsaegwon.kro.kr/set_location'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              HttpHeaders.authorizationHeader: 'Bearer ${widget.token}',
            },
            body: msg);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

      if (LocationInfo.fromJson(json.decode(response.body)).ok == true) {
        final _loginSnackBar = SnackBar(
          content: Text("영업 종료!"),
        );

        ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);
        Navigator.of(context).pop();
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => boong_main("", "")));
      }
      return LocationInfo.fromJson(json.decode(response.body));
    } else {
      final _loginSnackBar = SnackBar(
        content: Text("영업 종료 실패! 관리자에게 문의하세요."),
      );

      ScaffoldMessenger.of(context).showSnackBar(_loginSnackBar);
      throw Exception('Error : Failed to login');
    }
  }

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

                    fetchLocation(widget.id, widget.lat, widget.lng);
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(fontSize: 20),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'No',
                    style: TextStyle(fontSize: 20),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text("영업 중..."),
              backgroundColor: Colors.black26,
            ),
            body: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: <Widget>[
                  const SizedBox(
                    height: 50.0,
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                  ),
                  ElevatedButton(
                      onPressed:
                          isTrue == true ? () => _closing(context) : null,
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontSize: 40, color: Colors.white)),
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black45),
                      ),
                      child: Text("영업종료")),
                ],
              ),
            )),
        onWillPop: () async => false);
  }
}
