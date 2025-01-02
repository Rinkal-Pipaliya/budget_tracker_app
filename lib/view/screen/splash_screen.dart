import 'dart:async';

import 'package:budget_tracker_app/get_pages/get_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(
      const Duration(
        seconds: 3,
      ),
      () {
        Get.offNamed(GetPages.home);
      },
    );
    return const Scaffold(
      body: Center(
        child: Image(
          image: AssetImage(
            "assets/image/splash.png",
          ),
          height: 200,
          width: 200,
        ),
      ),
    );
  }
}
