import 'package:budget_tracker_app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(
    const MyApp(),
  );
}
