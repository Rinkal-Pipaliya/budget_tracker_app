import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:budget_tracker_app/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  int? categoryIndex;
  Future<List<CategoryModel>>? allCategory;

  //default constructor
  CategoryController() {
    fetchCategory();
  }

  void getIndex({required int index}) {
    categoryIndex = index;
    update();
  }

  void assignDefaultIndex() {
    categoryIndex = null;
    update();
  }

  // category record insertion

  Future<void> insertCategory({
    required String name,
    required Uint8List image,
  }) async {
    int? res = await DBHelper.helper.insertCategory(
      name: name,
      image: image,
      index: categoryIndex!,
    );
    if (res != null) {
      Get.snackbar(
        "Success",
        "$name category added successfully...!!: $res",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Error",
        "$name category is not added..",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
  }

  void fetchCategory() async {
    allCategory = DBHelper.helper.fetchCategory();
  }

  // search category
  void searchCategory({required String value}) async {
    allCategory = DBHelper.helper.liveSearchCategory(search: value);

    update();
  }

  // delete category
  Future<void> deleteCategory({required int id}) async {
    int? res = await DBHelper.helper.deleteCategory(id: id);
    if (res != null) {
      Get.snackbar(
        "Delete",
        "Category deleted successfully...!!: $res",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Error",
        "Category is not deleted..",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    update();
  }

  // update category

  void updateCategory({required CategoryModel category}) async {
    int? res = await DBHelper.helper.updateCategory(category: category);
    if (res != null) {
      Get.snackbar(
        "Update",
        "${category.name} category updated successfully...!!: $res",
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } else {
      Get.snackbar(
        "Error",
        "${category.name} category is not updated..",
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }

    update();
  }
}
