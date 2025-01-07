import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:budget_tracker_app/model/spending_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SpendingController extends GetxController {
  String? mode;
  DateTime? date;

  int? sIndex;
  int categoryId = 0;

  void getSpendingMode(String? value) {
    mode = value;
    update();
  }

  void getSpendingDate({required DateTime? value}) {
    date = value;
    update();
  }

  void getSpendingIndex({required int index, required int id}) {
    sIndex = index;
    categoryId = id;
    update();
  }

  Future<void> addSpendingDate({required SpendingModel spending}) async {
    int? res = await DBHelper.helper.insertSpending(spending: spending);

    if (res != null) {
      Get.snackbar(
        "Insert Success",
        "Spending added successfully...!!: $res",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Error",
        "Spending is not added..",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }
}
