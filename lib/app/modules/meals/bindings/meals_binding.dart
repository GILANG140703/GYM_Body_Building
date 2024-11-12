import 'package:get/get.dart';

import '../../../data/services/meals_controller.dart';

class MealsBinding extends Bindings {
  @override
  void dependencies() {
    // Bind MealsController lazily
    Get.lazyPut<MealsController>(() => MealsController());
  }
}
