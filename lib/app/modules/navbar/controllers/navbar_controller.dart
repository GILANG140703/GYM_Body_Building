import 'package:flutter/material.dart';
import 'package:flutter_application_prak/app/modules/podcast/views/podcast_view.dart';
import 'package:flutter_application_prak/app/modules/progress/views/progress_view.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../latihan/views/latihan_view.dart';

import '../../meals/views/meals_view.dart';
import '../../profil/views/profil_view.dart';
// import '../../meals/views/meals_view.dart'; // Pastikan ini ada

class NavbarController extends GetxController {
  final PersistentTabController tabController =
      PersistentTabController(initialIndex: 0);

  List<Widget> buildScreens() {
    return [
      // Routes.LATIHAN;
      const LatihanView(),
      MealsView(), // i
      ProgressView(),
      PodcastView(),
      ProfilView(),
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.fitness_center),
        title: "Latihan",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.restaurant), // Pastikan ini sesuai
        title: "Meals",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.assessment),
        title: "Progress", // Add title for Progress view
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.podcasts), // Icon untuk Podcast
        title: "Podcast",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        title: "Profil",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
