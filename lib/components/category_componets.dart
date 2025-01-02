import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math';

List<String> categoryImage = [
  "assets/image/bill.png",
  "assets/image/case.png",
  "assets/image/communication.png",
  "assets/image/deposit.png",
  "assets/image/food.png",
  "assets/image/gift.png",
  "assets/image/health.png",
  "assets/image/movie.png",
  "assets/image/rupee.png",
  "assets/image/salary.png",
  "assets/image/shopping.png",
  "assets/image/transport.png",
  "assets/image/wallet.png",
  "assets/image/withdraw.png",
  "assets/image/other.png",
];

GlobalKey<FormState> formKey = GlobalKey();
TextEditingController nameController = TextEditingController();

class CategoryComponents extends StatelessWidget {
  const CategoryComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select a Category",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Form(
              key: formKey,
              child: TextFormField(
                controller: nameController,
                validator: (val) =>
                    val!.isEmpty ? "Category name is required" : null,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  prefixIcon: const Icon(
                    Icons.category,
                  ),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: categoryImage.length,
                itemBuilder: (context, index) {
                  return GetBuilder<CategoryController>(
                    builder: (controller) {
                      return GestureDetector(
                        onTap: () {
                          controller.getIndex(index: index);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: controller.categoryIndex == index
                                  ? Colors.teal
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: AssetImage(categoryImage[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: controller.categoryIndex == index
                              ? const Align(
                                  alignment: Alignment.topRight,
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                )
                              : null,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton.extended(
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        controller.categoryIndex != null) {
                      String name = nameController.text;
                      String assetPath =
                          categoryImage[controller.categoryIndex!];
                      ByteData byteData = await rootBundle.load(assetPath);
                      Uint8List image = byteData.buffer.asUint8List();
                      int? res = await DBHelper.helper.insertCategory(
                        name: name,
                        image: image,
                      );

                      if (res != null) {
                        Get.snackbar(
                          "Success",
                          "$name category added successfully! Unique ID: $res",
                          colorText: Colors.white,
                          backgroundColor: Colors.green,
                        );
                      } else {
                        Get.snackbar(
                          "Error",
                          "$name category could not be added",
                          colorText: Colors.white,
                          backgroundColor: Colors.red,
                        );
                      }
                    } else {
                      Get.snackbar(
                        "Required",
                        "Please select a category name and image",
                        colorText: Colors.white,
                        backgroundColor: Colors.red.shade900,
                      );
                    }
                    nameController.clear();
                    controller.assignDefaultIndex();
                  },
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 28,
                  ),
                  label: const Text(
                    "Add Category",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w200,
                        color: Colors.black),
                  ),
                  backgroundColor: Colors.white,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
