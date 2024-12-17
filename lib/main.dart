import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_prak/dependecy_injection.dart';
import 'package:flutter_application_prak/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Tambahkan GetStorage
import 'package:shared_preferences/shared_preferences.dart';

import 'app/modules/handler_notification/notification_handler.dart';
import 'app/routes/app_pages.dart';

/// Fungsi untuk inisialisasi Firebase
Future<void> initializeFirebase() async {
  // Cek apakah sudah ada instance Firebase dengan nama 'flutter_application_prak'
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: "flutter_application_prak",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

void main() async {
  // Pastikan binding Flutter telah diinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase jika belum ada instance
  await initializeFirebase();

  // Inisialisasi GetStorage
  await GetStorage.init(); // Tambahkan inisialisasi ini

  // Inisialisasi SharedPreferences
  await Get.putAsync(() async => await SharedPreferences.getInstance());

  // Inisialisasi Push Notification Handler
  final notificationHandler = FirebaseMessagingHandler();
  await notificationHandler.initPushNotification();

  // Panggil Dependency Injection untuk mengatur bindings
  DependencyInjection.init();

  // Jalankan aplikasi Flutter menggunakan GetMaterialApp
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Application",
    initialRoute: AppPages.INITIAL, // Rute awal aplikasi
    getPages: AppPages.routes, // Rute halaman yang tersedia
  ));
}
