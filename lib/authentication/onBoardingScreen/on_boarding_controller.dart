import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cehpoint_marketplace/common/utils.dart';
import 'package:cehpoint_marketplace/routes/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingController extends GetxController {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  void onPageChange(int val) {
    currentIndex = val;
    update();
  }

  Future<void> nextButtonFunc(BuildContext context) async {
    if (currentIndex >= 2) {
      Get.offAllNamed(AppRoutes.authHome);
      final pref = await SharedPreferences.getInstance();
      pref.setInt(GlobalUtil.onBordingToken, 1);
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }
}
