import 'package:get/get.dart';

import '../modules/latihan/bindings/latihan_binding.dart';
import '../modules/latihan/views/latihan_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/meals/views/meals_view.dart';
import '../modules/profil/bindings/profil_binding.dart';
import '../modules/profil/views/profil_view.dart';
import '../modules/progress/bindings/progress_binding.dart';
import '../modules/progress/views/progress_view.dart';

// import '../modules/home/bindings/home_binding.dart';
// import '../modules/home/views/home_view.dart';
// import '../modules/meals_detail/views/meals_detail_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    // Add Latihan route
    GetPage(
      name: _Paths.LATIHAN,
      page: () => const LatihanView(),
      binding: LatihanBinding(),
    ),
    // Add Profil route
    GetPage(
      name: Routes.MEALS_DETAIL,
      page: () => MealsView(), // Mengambil meal dari arguments
    ),
    GetPage(
      name: _Paths.PROFIL,
      page: () => ProfilView(),
      binding: ProfilBinding(),
    ),

    // Uncomment the Home route if needed
    // GetPage(
    //   name: _Paths.HOME,
    //   page: () => const HomeView(),
    //   binding: HomeBinding(),
    // ),
    GetPage(
      name: _Paths.PROGRESS,
      page: () => ProgressView(),
      binding: ProgressBinding(),
    ),
  ];
}
