import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'boong_infoEdit.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '영업일시 및 장소 수정',
      home: timeEdit(),
    );
  }
}


class timeEdit extends StatefulWidget {
  @override
  timeEditState createState() => timeEditState();
}

class timeEditState extends State<timeEdit> {

  final formKey = GlobalKey<FormState>();
  String _openTime = '';
  String _openDay = '';
  String _location = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
          title: Text('영업 일시/장소 수정'),
        ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('영업 요일', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal,),),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    hintText: 'ex) 매월 첫째, 셋째주 월, 화요일 ',
                  ),
                  onSaved: (value) {
                    setState(() {
                      _openDay = value as String;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '입력되지 않았습니다.';
                    } return null;
                  },
                ),



                SizedBox(height: 20,),

                const Text('영업 시간', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal,)),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    hintText: 'ex) 오후 6시부터 오후 10시까지',
                  ),
                  onSaved: (value) {
                    setState(() {
                      _openTime = value as String;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '입력되지 않았습니다.';
                    } return null;
                  },
                ),
                SizedBox(height: 20,),

                const Text('영업 장소', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal,)),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  decoration: const InputDecoration(
                    hintText: 'ex) 대전 궁동 충남대 후문 앞',
                  ),
                  onSaved: (value) {
                    setState(() {
                      _location = value as String;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '입력되지 않았습니다.';
                    } return null;
                  },
                ),
                const SizedBox(height: 40.0,),
                Container(
                  width: 1000,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      OutlinedButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(_openDay+'/'+_openTime+'/'+_location)),
                            );
                            Navigator.pop(context);
                          }
                        },
                        style: OutlinedButton.styleFrom(side: BorderSide(width: 1.0, color: Colors.black),),
                        child: const Text('완료', style: TextStyle(color: Colors.black, fontSize: 19), ),
                      )
                    ],
                  )
                ),

              ],
           )
        )
        ),

      );
  }
}
