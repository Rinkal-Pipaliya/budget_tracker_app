import 'package:budget_tracker_app/view/screen/home_screen.dart';
import 'package:budget_tracker_app/view/screen/splash_screen.dart';
import 'package:get/get.dart';

class GetPages {
  static String splash = '/';
  static String home = '/home';

  static List<GetPage> pages = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      // transition: Transition.downToUp,
    ),
    GetPage(
      name: home,
      page: () => const HomeScreen(),
      // transition: Transition.downToUp,
    ),
  ];
}
