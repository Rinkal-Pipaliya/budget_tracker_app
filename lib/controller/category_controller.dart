import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:budget_tracker_app/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  int? categoryIndex;
  Future<List<CategoryModel>>? allCategory;

  // Default Constructor
  // CategoryController() {
  //   fetchCategoryData();
  // }

  void getCategoryIndex({required int index}) {
    categoryIndex = index;

    update();
  }

  void assignDefaultVal() {
    categoryIndex = null;

    update();
  }

  // Insert Category Record
  Future<void> addCategoryData({
    required String name,
    required Uint8List image,
  }) async {
    int? res = await DBHelper.helper
        .insertCategory(name: name, image: image, index: categoryIndex!);

    if (res != null) {
      Get.snackbar(
        "Insert",
        "$name category is inserted....$res",
        colorText: Colors.white,
        backgroundColor: Colors.green.shade300,
      );
    } else {
      Get.snackbar(
        "Failed",
        "$name category is Insertion failed....",
        colorText: Colors.white,
        backgroundColor: Colors.red.shade300,
      );
    }
  }

  // Fetch Records
  void fetchCategoryData() {
    allCategory = DBHelper.helper.fetchCategory();
  }

  // Live Search
  void searchData({required String val}) {
    allCategory = DBHelper.helper.liveSearchCategory(search: val);

    update();
  }

  // Delete Record
  Future<void> deleteCategory({required int id}) async {
    int? res = await DBHelper.helper.deleteCategory(id: id);

    if (res != null) {
      fetchCategoryData();
      Get.snackbar(
        'DELETED',
        "Category is deleted...",
        backgroundColor: Colors.green.withOpacity(0.7),
      );
    } else {
      Get.snackbar(
        'Failed',
        "Category is deletion failed...",
        backgroundColor: Colors.red.withOpacity(0.7),
      );
    }

    update();
  }

  // Update Record
  Future<void> updateCategoryData({required CategoryModel model}) async {
    int? res =
        await DBHelper.helper.updateCategory(model: model, category: model);

    if (res != null) {
      fetchCategoryData();
      Get.snackbar(
        'Update',
        "Category is updated...",
        backgroundColor: Colors.green.withOpacity(0.7),
      );
    } else {
      Get.snackbar(
        'Failed',
        "Category is updation failed...",
        backgroundColor: Colors.red.withOpacity(0.7),
      );
    }

    update();
  }
}
