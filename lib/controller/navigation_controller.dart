import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;
  PageController pageController = PageController(initialPage: 0);

  void getIndex({required int index}) {
    selectedIndex.value = index;
  }

  void changePage({required int index}) {
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.bounceInOut,
    );
    update();
  }
}
