import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

List<String> categoryImages = [
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
List<String> categoryName = [
  "Bill",
  "Case",
  "Communication",
  "Deposit",
  "Food",
  "Gift",
  "Health",
  "Movie",
  "Rupee",
  "Salary",
  "Shopping",
  "Transport",
  "Wallet",
  "Withdraw",
  "Other",
];

GlobalKey<FormState> categoryKey = GlobalKey<FormState>();
TextEditingController categoryNameController = TextEditingController();

class CategoryComponents extends StatelessWidget {
  const CategoryComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: categoryKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Choose a Category",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Enter category name and select an icon",
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 20.h),
              TextFormField(
                controller: categoryNameController,
                validator: (val) =>
                    val!.isEmpty ? "Category name is required" : null,
                decoration: InputDecoration(
                  labelText: "Category Name",
                  hintText: "Enter category name",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 14.h,
                    horizontal: 16.w,
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                "Select Icon",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
              SizedBox(height: 10.h),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryImages.length,
                  itemBuilder: (ctx, index) =>
                      GetBuilder<CategoryController>(builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        controller.getCategoryIndex(index: index);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.h),
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: (controller.categoryIndex == index)
                                ? Colors.green.shade500
                                : Colors.grey.shade300,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(categoryImages[index]),
                                  fit: BoxFit.contain,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                categoryName[index],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            if (controller.categoryIndex == index)
                              const Icon(
                                CupertinoIcons.check_mark_circled_solid,
                                color: Colors.green,
                              )
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green.shade700,
        label: const Text("Add Category"),
        onPressed: () async {
          if (categoryKey.currentState!.validate() &&
              controller.categoryIndex != null) {
            String name = categoryNameController.text;

            String assetPath = categoryImages[controller.categoryIndex!];

            ByteData byteData = await rootBundle.load(assetPath);

            Uint8List image = byteData.buffer.asUint8List();

            controller.addCategoryData(name: name, image: image);

            Get.snackbar(
              "Success",
              "Category added successfully!",
              colorText: Colors.white,
              backgroundColor: Colors.green,
            );
          } else {
            Get.snackbar(
              "Error",
              "Please provide category name and select an icon.",
              colorText: Colors.white,
              backgroundColor: Colors.redAccent,
            );
          }

          categoryNameController.clear();
          controller.assignDefaultVal();
        },
      ),
    );
  }
}
