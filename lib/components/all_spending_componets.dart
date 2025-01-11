import 'package:budget_tracker_app/helper/db_helper.dart';
import 'package:budget_tracker_app/model/spending_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllSpendingComponents extends StatelessWidget {
  const AllSpendingComponents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: DBHelper.helper.fetchSpending(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<SpendingModel> spendingData = snapshot.data ?? [];

            return ListView.builder(
              itemCount: spendingData.length,
              itemBuilder: (context, index) {
                var data = SpendingModel(
                    id: spendingData[index].id,
                    desc: spendingData[index].desc,
                    amount: spendingData[index].amount,
                    mode: spendingData[index].mode,
                    date: spendingData[index].date,
                    categoryId: spendingData[index].categoryId);
                return Container(
                  height: 200.h,
                  width: double.infinity,
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        spendingData[index].desc,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        "₹ ${spendingData[index].amount}",
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            "DATE : ",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            data.date,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      FutureBuilder(
                        future: DBHelper.helper
                            .fetchSingleCategory(id: data.categoryId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return (snapshot.data != null)
                                ? Text(
                                    snapshot.data!.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  )
                                : Container();
                          }
                          return Container();
                        },
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          FutureBuilder(
                            future: DBHelper.helper
                                .fetchSingleCategory(id: data.categoryId),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return (snapshot.data != null)
                                    ? Image.memory(
                                        snapshot.data!.image,
                                        height: 50,
                                      )
                                    : Container();
                              }
                              return Container();
                            },
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          ActionChip(
                            color: WidgetStateProperty.all(
                              (data.mode == 'online')
                                  ? Colors.green
                                  : Colors.yellow,
                            ),
                            label: Text(data.mode),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              )),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.redAccent,
                              )),
                        ],
                      )
                    ],
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
    );
  }
}
