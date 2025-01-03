import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

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

List<String> categoryNames = [
  "Bills",
  "Case",
  "Communication",
  "Deposit",
  "Food",
  "Gifts",
  "Health",
  "Movies",
  "Finance",
  "Salary",
  "Shopping",
  "Transport",
  "Wallet",
  "Withdraw",
  "Other",
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
              "Add Category",
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
                    color: Colors.green,
                  ),
                  labelStyle: const TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.green, width: 2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: categoryImage.length,
                itemBuilder: (context, index) {
                  return GetBuilder<CategoryController>(
                    builder: (controller) {
                      return GestureDetector(
                        onTap: () {
                          controller.getIndex(index: index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            border: Border.all(
                              color: controller.categoryIndex == index
                                  ? Colors.green.shade500
                                  : Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  categoryImage[index],
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  categoryNames[index],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              if (controller.categoryIndex == index)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                ),
                            ],
                          ),
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
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate() &&
                        controller.categoryIndex != null) {
                      String name = nameController.text;
                      String assetPath =
                          categoryImage[controller.categoryIndex!];
                      ByteData byteData = await rootBundle.load(assetPath);
                      Uint8List image = byteData.buffer.asUint8List();

                      controller.insertCategory(name: name, image: image);
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade500,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Add Category"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
