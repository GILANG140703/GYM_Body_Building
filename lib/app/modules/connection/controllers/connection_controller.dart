import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_application_prak/app/modules/navbar/views/navbar_view.dart';
import '../views/connection_view.dart';

class ConnectionController extends GetxController {
  final Connectivity _connectivity = Connectivity();
  String _lastRoute = '/'; // Variabel untuk menyimpan rute terakhir

  @override
  void onInit() {
    super.onInit();
    // Menyimpan rute awal
    _lastRoute = Get.currentRoute;

    // Memantau perubahan koneksi
    _connectivity.onConnectivityChanged.listen((connectivityResults) {
      _updateConnectionStatus(connectivityResults.first);
    });

    // Mengecek koneksi awal saat aplikasi dimulai
    checkConnection();
  }

  // Fungsi untuk mengecek koneksi awal
  void checkConnection() async {
    var result = await _connectivity.checkConnectivity();
    _updateConnectionStatus(result.first);
  }

  // Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      // Simpan rute terakhir sebelum berpindah ke NoConnectionView
      _lastRoute = Get.currentRoute;
      Get.offAll(() => const NoConnectionView());
    } else {
      // Jika koneksi kembali normal, kembali ke rute terakhir
      if (Get.currentRoute == '/NoConnectionView') {
        if (_lastRoute == '/NoConnectionView' || _lastRoute == '/') {
          // Jika rute terakhir adalah halaman awal, arahkan ke NavbarView
          Get.offAll(() => const NavbarView());
        } else {
          // Jika rute terakhir bukan halaman awal, kembali ke halaman terakhir
          Get.offAllNamed(_lastRoute);
        }
      }
    }
  }
}
