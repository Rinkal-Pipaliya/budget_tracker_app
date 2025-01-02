import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:budget_tracker_app/controller/navigation_controller.dart';
import 'package:budget_tracker_app/components/all_category_components.dart';
import 'package:budget_tracker_app/components/all_spending_componets.dart';
import 'package:budget_tracker_app/components/category_componets.dart';
import 'package:budget_tracker_app/components/spending_componets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NavigationController controller = Get.put(
      NavigationController(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Budget Tracker",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      body: PageView(
        controller: controller.pageController,
        onPageChanged: (index) => controller.getIndex(index: index),
        children: const [
          AllSpendingComponets(),
          SpendingComponets(),
          AllCategoryComponents(),
          CategoryComponents(),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.getIndex(index: index);
            controller.changePage(index: index);
          },
          selectedItemColor: Colors.green.shade800,
          unselectedItemColor: Colors.black87,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.price_check),
              label: "All Spending",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.attach_money),
              label: "Spending",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long),
              label: "All Category",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Category",
            ),
          ],
        ),
      ),
    );
  }
}
