import '../../../routes/app_pages.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  String? _lastRoute;

  @override
  void onInit() {
    super.onInit();

    _lastRoute = Get.currentRoute;

    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      _updateConnectionStatus(connectivityResult.first);
    });
  }

  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    print('Connectivity Result: $connectivityResult');
    print('Last Route: $_lastRoute');

    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        'No Connection',
        'You are offline. Please check your internet connection.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else if (connectivityResult == ConnectivityResult.wifi) {
      Get.snackbar(
        'Connected to Wi-Fi',
        'You are now connected to Wi-Fi.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    } else if (connectivityResult == ConnectivityResult.mobile) {
      Get.snackbar(
        'Connected to Mobile Data',
        'You are now connected to mobile data.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue.withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
    }

    if (connectivityResult != ConnectivityResult.none) {
      if (_lastRoute != null) {
        print('Navigating back to $_lastRoute');
        Get.offAllNamed(_lastRoute!);
      } else {
        print('Navigating to LoginView');
        Get.offAllNamed(Routes.LOGIN);
      }
    }
  }
}
