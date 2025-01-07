import 'package:budget_tracker_app/controller/spending_controller.dart';
import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:budget_tracker_app/model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../model/spending_model.dart';

TextEditingController descriptionController = TextEditingController();
TextEditingController amountController = TextEditingController();

GlobalKey<FormState> spendingKey = GlobalKey<FormState>();

class SpendingComponets extends StatelessWidget {
  const SpendingComponets({super.key});

  @override
  Widget build(BuildContext context) {
    SpendingController controller = Get.put(SpendingController());
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextFormField(
            maxLines: 2,
            controller: descriptionController,
            validator: (val) => val!.isEmpty ? "Description is required" : null,
            decoration: InputDecoration(
              labelText: "Description",
              hintText: "Enter Description",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.deepPurpleAccent,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          TextFormField(
            controller: amountController,
            validator: (val) => val!.isEmpty ? "Amount is required" : null,
            decoration: InputDecoration(
              labelText: "Amount",
              hintText: "Enter Amount",
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.deepPurpleAccent,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.red,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          Row(
            children: [
              Text(
                "MODE :",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              DropdownButton(
                value: controller.mode,
                items: const [
                  DropdownMenuItem(
                    value: "Online",
                    child: Text("Expense"),
                  ),
                  DropdownMenuItem(
                    value: "Offline",
                    child: Text("Income"),
                  ),
                ],
                onChanged: controller.getSpendingMode,
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "DATE :",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2026),
                  );

                  if (date != null) {
                    controller.getSpendingDate(value: date);
                  }
                },
                icon: const Icon(Icons.date_range),
              ),
              if (controller.date != null)
                Text(
                  "${controller.date?.day}/${controller.date?.month}/${controller.date?.year}",
                )
              else
                const Text("DD/MM/YYYY"),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: DBHelper.helper.fetchCategory(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  List<CategoryModel> allCategory = snapshot.data ?? [];
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemCount: allCategory.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          controller.getSpendingIndex(
                            index: index,
                            id: allCategory[index].id,
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                                color: (index == controller.sIndex)
                                    ? Colors.grey
                                    : Colors.transparent),
                            image: DecorationImage(
                              image: MemoryImage(allCategory[index].image),
                            ),
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
          FloatingActionButton.extended(
            onPressed: () {
              if (spendingKey.currentState!.validate() &&
                  controller.mode != null &&
                  controller.date != null &&
                  controller.sIndex != null) {
                controller.addSpendingDate(
                    spending: SpendingModel(
                  id: 0,
                  desc: descriptionController.text,
                  amount: double.parse(amountController.text),
                  mode: controller.mode!,
                  date:
                      "${controller.date!.day}/${controller.date!.month}/${controller.date!.year}",
                  categoryId: controller.categoryId,
                ));
              } else {
                Get.snackbar(
                  "Error",
                  "All fields are required",
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
              }
            },
            label: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
