import 'package:get/get.dart';
import 'dart:io';

class storeCotroller extends GetxController {
  String storeName = "";
  String category = "";
  List<File> image = <File>[];
  String storeInfo = "";
  int _imageLen = 0;

  void categoryInfoAdd(String _Category) {
    category = _Category;
    update();
  }

  void storeNameAdd(String _StoreName) {
    storeName = _StoreName;
    update();
  }

  void storeInfoAdd(String _StoreInfo) {
    storeInfo = _StoreInfo;
    update();
  }

  void imageAdd(File _Image) {
    image.add(_Image);
    update();
  }

  List<File> images() {
    return image;
  }

  void plusImageLen() {
    _imageLen++;
    update();
  }
}
