import 'package:flutter/material.dart';

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

class makeProfile extends StatefulWidget {
  @override
  makeProfileState createState() => makeProfileState();
}

class makeProfileState extends State<makeProfile> {
  final formKey = GlobalKey<FormState>();
  String _id = '';
  String _pwd = '';
  String _pwdCheck = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("회원가입"),
        backgroundColor: Colors.black26,
      ),
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    '아이디',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                      hintText: '아이디를 입력해 주세요.',
                    ),
                    onSaved: (value) {
                      setState(() {
                        _id = value as String;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '입력되지 않았습니다.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                children: [
                  const Text(
                    '비밀번호',
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.always,
                    decoration: const InputDecoration(
                      hintText: '비밀번호를 입력해 주세요.',
                    ),
                    onSaved: (value) {
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
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(_id+'/'+_pwd)),
                        );
                      }
                      },
                    child: const Text('Submit'),
                  )



                ],
              ),
            )
          ]

        ),
      ),
    );
  }

}