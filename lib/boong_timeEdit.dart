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
    Map<String, bool> numbers = {
      'One' : false,
      'Two' : false,
      'Three' : false,
      'Four' : false,
      'Five' : false,
      'Six' : false,
      'Seven' : false,
    };

    var holder_1 = [];

    getItems() {
      numbers.forEach((key, value) {
        if (value == true) {
          holder_1.add(key);
        }
      });
      print(holder_1);
      // Here you will get all your selected Checkbox items.

      // Clear array after use.
      holder_1.clear();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black26,
        ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
           child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget> [
                const Text('영업 일시/장소 수정', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                Container(width: 100, child: const Divider(color: Colors.black, thickness: 1.0)),

                const Text('무슨 요일에', style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),),
              //왜 안뜨는거야;;;;;;
                ListView(
                  children: numbers.keys.map((String key) {
                    return new CheckboxListTile(
                      title: new Text(key),
                      value: numbers[key],
                      activeColor: Colors.pink,
                      checkColor: Colors.white,
                      onChanged: (bool? value) {
                          setState(() {
                            numbers[key] = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                // CheckboxListTile(
                //   title: Text('월'),
                //   value: _isChecked1,
                //   onChanged: (value) {
                //     setState(() {
                //       _isChecked1 = value!;
                //     });
                //   },
                // ),
                // CheckboxListTile(
                //   title: Text('화'),
                //   value: _isChecked2,
                //   onChanged: (value) {
                //     setState(() {
                //       _isChecked2 = value!;
                //     });
                //   },
                // ),
                // Row(
                //   children: <Widget> [
                //
                //     // Text('월', style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),),
                //     // Checkbox(value: _isChecked1, onChanged: (value){
                //     //   setState(() {
                //     //     _isChecked1 = value!;
                //     //   });
                //     // },),
                //     // Checkbox(value: _isChecked2, onChanged: (value){
                //     //   setState(() {
                //     //     _isChecked2 = value!;
                //     //   });
                //     // },),
                //   ],
                // ),
              ],

           )
        ),

      ),
    );
  }
}