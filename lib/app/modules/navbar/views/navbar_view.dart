import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:get/get.dart';
import '../controllers/navbar_controller.dart';
// import '../latihan/latihan_view.dart';
// import '../profil/profil_view.dart';
// import 'navbar_controller.dart';

class NavbarView extends StatelessWidget {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final NavbarController controller = Get.put(NavbarController());

    return PersistentTabView(
      context,
      controller: controller.tabController,
      screens: controller.buildScreens(),
      items: controller.navBarsItems(),
      backgroundColor: Colors.white,
      navBarStyle: NavBarStyle.style1,
    );
  }
}
