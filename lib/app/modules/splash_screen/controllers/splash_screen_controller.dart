import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToLogin();
  }

  void navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3)); // Splash duration
    Get.offNamed('/login');
  }
}
