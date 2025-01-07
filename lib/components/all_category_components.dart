import 'dart:developer';
import 'package:budget_tracker_app/components/category_componets.dart';
import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:budget_tracker_app/model/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:swipeable_tile/swipeable_tile.dart';

class AllCategoryComponents extends StatelessWidget {
  const AllCategoryComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    controller.fetchCategory();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (value) async {
              log("DATA : $value");
              controller.searchCategory(value: value);
            },
            decoration: InputDecoration(
              prefixIcon: const Icon(CupertinoIcons.search),
              hintText: "Search Categories",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: GetBuilder<CategoryController>(builder: (context) {
              return FutureBuilder(
                future: controller.allCategory,
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return Center(
                      child: Text("ERROR: ${snapShot.error}"),
                    );
                  } else if (snapShot.hasData) {
                    List<CategoryModel> allCategoryData = snapShot.data ?? [];
                    return (allCategoryData.isNotEmpty)
                        ? ListView.builder(
                            itemCount: allCategoryData.length,
                            itemBuilder: (context, index) {
                              CategoryModel data = allCategoryData[index];
                              return SwipeableTile(
                                key: ValueKey(data.id), // Unique Key
                                color: Colors.transparent,
                                swipeThreshold: 0.2,
                                direction: SwipeDirection.endToStart,
                                onSwiped: (direction) {
                                  if (direction == SwipeDirection.endToStart) {
                                    controller
                                        .deleteCategory(id: data.id)
                                        .then((_) {
                                      controller.fetchCategory();
                                    });
                                  }
                                },
                                backgroundBuilder:
                                    (context, direction, progress) {
                                  return Container(
                                    color: Colors.red,
                                    alignment: Alignment.centerRight,
                                    padding: EdgeInsets.only(right: 20.w),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                                child: Card(
                                  margin: EdgeInsets.symmetric(vertical: 8.h),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 26.w,
                                      backgroundImage: MemoryImage(data.image),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    title: Text(
                                      data.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        nameController.text = data.name;
                                        controller.assignDefaultIndex();

                                        Get.bottomSheet(
                                          Container(
                                            padding: const EdgeInsets.all(16),
                                            height: 300.h,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Form(
                                              key: formKey,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    "Edit Category",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  TextFormField(
                                                    controller: nameController,
                                                    validator: (val) => val!
                                                            .isEmpty
                                                        ? "Category name is required"
                                                        : null,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          "Category Name",
                                                      prefixIcon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.green,
                                                      ),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 20.h),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      if (formKey.currentState!
                                                          .validate()) {
                                                        controller
                                                            .updateCategory(
                                                                category: data);
                                                        Get.back();
                                                      }
                                                    },
                                                    child: const Text("Update"),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text("No Categories Found"),
                          );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
