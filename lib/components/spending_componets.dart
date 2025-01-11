import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:budget_tracker_app/model/category_model.dart';
import 'package:budget_tracker_app/model/spending_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../helper/db_helper.dart';

TextEditingController descController = TextEditingController();
TextEditingController amountController = TextEditingController();

GlobalKey<FormState> spendingKey = GlobalKey<FormState>();

class SpendingComponents extends StatelessWidget {
  const SpendingComponents({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: GetBuilder<SpendingController>(
          builder: (ctx) {
            return Form(
              key: spendingKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      "Track Your Spending",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Spending Details Card
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Column(
                          children: [
                            // Description Input
                            TextFormField(
                              controller: descController,
                              maxLines: 2,
                              validator: (val) => val!.isEmpty
                                  ? "Description is required"
                                  : null,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.description_outlined),
                                labelText: "Description",
                                hintText: "Enter spending description...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            SizedBox(height: 15.h),

                            // Amount Input
                            TextFormField(
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              validator: (val) =>
                                  val!.isEmpty ? "Amount is required" : null,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.attach_money_outlined),
                                labelText: "Amount",
                                hintText: "Enter spending amount...",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 15.h),

                    // Mode and Date Selection
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Mode Dropdown
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 3,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: DropdownButton<String>(
                                value: controller.mode,
                                hint: const Text("Select Mode"),
                                items: const [
                                  DropdownMenuItem(
                                    value: "online",
                                    child: Text(
                                      "Online",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: "offline",
                                    child: Text(
                                      "Offline",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                                onChanged: controller.getSpendingMode,
                                underline: SizedBox(),
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),

                        // Date Picker
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              DateTime? date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2026),
                              );

                              if (date != null) {
                                controller.getSpendingDate(date: date);
                              }
                            },
                            child: Container(
                              height: 55.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.date_range_outlined,
                                      color: Colors.green),
                                  SizedBox(width: 5.w),
                                  Text(
                                    controller.dateTime != null
                                        ? "${controller.dateTime?.day}/${controller.dateTime?.month}/${controller.dateTime?.year}"
                                        : "Select Date",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),

                    // Category List
                    Text(
                      "Select Category",
                      style: TextStyle(
                        fontSize: 17.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    SizedBox(
                      height: 300.h,
                      child: FutureBuilder(
                        future: DBHelper.helper.fetchCategory(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<CategoryModel> category = snapshot.data ?? [];

                            return ListView.builder(
                              itemCount: category.length,
                              itemBuilder: (context, index) {
                                bool isSelected =
                                    index == controller.spendingIndex;
                                return GestureDetector(
                                  onTap: () {
                                    controller.getSpendingIndex(
                                      index: index,
                                      id: category[index].id,
                                    );
                                  },
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 5.h),
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? Colors.green.shade50
                                          : Colors.grey.shade200,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.green
                                            : Colors.grey.shade300,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundImage: MemoryImage(
                                              category[index].image),
                                          radius: 24,
                                        ),
                                        SizedBox(width: 10.w),
                                        Text(
                                          category[index].name,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            color: isSelected
                                                ? Colors.green.shade700
                                                : Colors.black87,
                                            fontWeight: isSelected
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Add Spending Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (spendingKey.currentState!.validate() &&
                              controller.mode != null &&
                              controller.dateTime != null &&
                              controller.spendingIndex != null) {
                            controller.addSpendingData(
                              model: SpendingModel(
                                id: 0,
                                desc: descController.text,
                                amount: num.parse(amountController.text),
                                mode: controller.mode!,
                                date:
                                    "${controller.dateTime?.day}/${controller.dateTime?.month}/${controller.dateTime?.year}",
                                categoryId: controller.categoryId,
                              ),
                            );
                            descController.clear();
                            amountController.clear();
                            controller.assignDefaultValue();
                          } else {
                            Get.snackbar(
                              "Error",
                              "Please fill all fields",
                              backgroundColor: Colors.red.shade300,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(vertical: 15.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Add Spending",
                          style:
                              TextStyle(fontSize: 18.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
