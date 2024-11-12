import 'package:flutter_application_prak/app/modules/login/controllers/login_controller.dart';
import 'package:get/get.dart';

// import '../controllers/home_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
