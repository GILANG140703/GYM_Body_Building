import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_prak/firebase_options.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/modules/handler_notification/notification_handler.dart';
import 'app/routes/app_pages.dart';

Future<void> initializeFirebase() async {
  // Cek apakah sudah ada instance Firebase dengan nama 'dev project'
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: "flutter_application_prak", // Menambahkan nama khusus
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

void main() async {
  // Pastikan binding telah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase jika belum ada instance
  await initializeFirebase();

  // Inisialisasi SharedPreferences atau fitur lainnya
  await Get.putAsync(() async => await SharedPreferences.getInstance());

  // Inisialisasi Push Notification Handler
  final notificationHandler = FirebaseMessagingHandler();
  await notificationHandler.initPushNotification();

  // Jalankan aplikasi
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Application",
    initialRoute: AppPages.INITIAL,
    getPages: AppPages.routes,
  ));
}
