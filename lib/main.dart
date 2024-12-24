import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_prak/dependecy_injection.dart';
import 'package:flutter_application_prak/firebase_options.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Tambahkan GetStorage
import 'package:shared_preferences/shared_preferences.dart';

import 'app/modules/handler_notification/notification_handler.dart';
import 'app/routes/app_pages.dart';


Future<void> initializeFirebase() async {
 
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      name: "flutter_application_prak",
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
}

void main() async {
 
  WidgetsFlutterBinding.ensureInitialized();

  
  await initializeFirebase();

  
  await GetStorage.init(); 

  
  await Get.putAsync(() async => await SharedPreferences.getInstance());

  
  final notificationHandler = FirebaseMessagingHandler();
  await notificationHandler.initPushNotification();

  
  
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Application",
    initialRoute: AppPages.INITIAL, 
    getPages: AppPages.routes, 
  ));
  DependencyInjection.init();
}
