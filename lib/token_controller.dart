import 'package:get/get.dart';

class token_controller extends GetxController {
  String Mytoken = "";

  void updateToken(String token) {
    this.Mytoken = token;
    update();
  }
}
