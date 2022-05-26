import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import'boong_info.dart';

Future<register> fetchRegister(String id, String pwd) async {
  final msg = jsonEncode({"id" : id, "password" : pwd});
  final response = await http.post(Uri.parse('http://boongsaegwon.kro.kr/register'),
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: msg);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return register.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load album');
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '계정 만들기',
      home: makeProfile(),
    );
  }
}

class register {
  Null? error;
  bool? ok;

  register({this.error, this.ok});

  register.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    ok = json['ok'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this.error;
    data['ok'] = this.ok;
    return data;
  }
}

class makeProfile extends StatefulWidget {
  @override
  makeProfileState createState() => makeProfileState();
}

class makeProfileState extends State<makeProfile> {
  final formKey = GlobalKey<FormState>();
  String _id = '';
  String _pwd = '';
  String _pwdCheck = '';
  late Future<register> futureAlbum;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
        title: Text("회원가입"),
        backgroundColor: Colors.black26,
      ),
      body: Form(
        key: formKey,
        child: Column(
            children: [
              const SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(child: Column(
                    children: [const Text(
                      '아이디',
                      style: TextStyle(
                        fontSize: 22.0,
                      ),
                    ),],
                  )),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                      hintText: '아이디를 입력해 주세요.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _id = value as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '입력되지 않았습니다.';
                      } return null;
                    },
                  ),

                ],
              ),
            ),
            const SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '비밀번호',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),


                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    keyboardType: TextInputType.visiblePassword,
                    // obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 입력해 주세요.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _pwd = value as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '입력되지 않았습니다.';
                      } if (value.toString().length < 8) {
                        return '8자 이상 입력해 주세요.';
                      } if (!RegExp('[0-9]').hasMatch(value)) {
                        return '숫자를 포함한 8자리 이상의 문자열로 만들어 주세요.';
                      } return null;
                    },
                    obscureText: true,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '비밀번호 확인',
                    style: TextStyle(
                      fontSize: 22.0,
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    // obscureText: true,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 다시 입력해 주세요.',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _pwdCheck = value as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '입력되지 않았습니다.';
                      }
                      if(value.toString() != _pwd) {
                        return '비밀번호가 일치하지 않습니다.';
                      }
                      return null;
                    },
                    obscureText: true,
                  ),
                  const SizedBox(height: 40.0,),

                ],
              ),
            ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    futureAlbum = fetchRegister(_id, _pwd);
                    FutureBuilder<register>(
                      future: futureAlbum,
                      builder: (context, snapshot) {
                        if(snapshot.hasData) {
                          if(snapshot.data?.ok == true) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_id+'/'+_pwd+'/'+_pwdCheck)),
                            );
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) => info()));
                          }
                          else {
                          }
                        }
                        else if (snapshot.hasError) {
                        }
                        return CircularProgressIndicator();
                      },
                    );

                  }
                },
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                      TextStyle(fontSize: 15, color: Colors.white)),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.black45),
                ),
                child: const Text('완료'),
              )

          ]

        ),
      ),
    );
  }

}