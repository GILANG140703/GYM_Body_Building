import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class FirebaseMessagingHandler {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Inisialisasi notifikasi push
  Future<void> initPushNotification() async {
    // Meminta izin untuk notifikasi (terutama di iOS)
    await _requestNotificationPermissions();

    // Konfigurasi notifikasi lokal
    await _initializeLocalNotifications();

    // Handle pesan ketika aplikasi di foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(message);
    });

    // Handle pesan ketika aplikasi dibuka dari background atau terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageTap(message);
    });

    final token = await _messaging.getToken();
    print('FCM Token: $token');

    // Cek apakah aplikasi dibuka dari notifikasi saat berada di terminated state
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageTap(initialMessage);
    }
  }

  // Meminta izin untuk notifikasi (khusus untuk iOS)
  Future<void> _requestNotificationPermissions() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  // Inisialisasi notifikasi lokal untuk menampilkan notifikasi ketika aplikasi di foreground
  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Menampilkan notifikasi lokal
  Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel_id', // Harus sama dengan yang ada di AndroidManifest.xml
      'Default Channel',
      channelDescription: 'This is the default channel for notifications.',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
    );
  }

  // Menghandle tap pada notifikasi (untuk membuka halaman tertentu, dll.)
  void _handleMessageTap(RemoteMessage message) {
    print('Notification clicked! ${message.notification?.title}');
    // Implementasi navigasi atau aksi yang diinginkan di sini
    Get.toNamed('/your-target-route'); // Misalnya: navigasi ke halaman tertentu
  }
}
