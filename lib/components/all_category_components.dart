import 'dart:developer';
import 'package:budget_tracker_app/controller/category_controller.dart';
import 'package:budget_tracker_app/model/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AllCategoryComponents extends StatelessWidget {
  const AllCategoryComponents({super.key});

  @override
  Widget build(BuildContext context) {
    CategoryController controller = Get.put(CategoryController());
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            onChanged: (value) async {
              log("DATA : $value");
              controller.searchCategory(value: value);
            },
            decoration: const InputDecoration(
              prefixIcon: Icon(CupertinoIcons.search),
              hintText: "Search",
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
            child: GetBuilder<CategoryController>(builder: (context) {
              return FutureBuilder(
                future: controller.allCategory,
                builder: (context, snapShot) {
                  if (snapShot.hasError) {
                    return Center(
                      child: Text("ERROR : ${snapShot.error}"),
                    );
                  } else if (snapShot.hasData) {
                    List<CategoryModel> allCategoryData = snapShot.data ?? [];

                    return (allCategoryData.isNotEmpty)
                        ? ListView.builder(
                            itemCount: allCategoryData.length,
                            itemBuilder: (context, index) {
                              CategoryModel data = CategoryModel(
                                id: allCategoryData[index].id,
                                name: allCategoryData[index].name,
                                image: allCategoryData[index].image,
                              );
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    radius: 26.w,
                                    backgroundImage: MemoryImage(data.image),
                                  ),
                                  title: Text(data.name),
                                ),
                              );
                            })
                        : const Center(
                            child: Text("No Data Found"),
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
