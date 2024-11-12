import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_prak/firebase_options.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/modules/handler_notification/notification_handler.dart';
import 'app/routes/app_pages.dart';
// Update with the correct import for your notification handler

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi SharedPreferences
  await Get.putAsync(() async => await SharedPreferences.getInstance());

  // Inisialisasi Push Notification
  final notificationHandler = FirebaseMessagingHandler();
  await notificationHandler.initPushNotification();

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
