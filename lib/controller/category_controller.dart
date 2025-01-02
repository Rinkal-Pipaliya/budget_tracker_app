import 'package:get/get.dart';

class CategoryController extends GetxController {
  int? categoryIndex;

  void getIndex({required int index}) {
    categoryIndex = index;
    update();
  }

  void assignDefaultIndex() {
    categoryIndex = null;
    update();
  }
}
