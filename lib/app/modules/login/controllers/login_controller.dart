import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:BodyBuilding/app/modules/login/views/login_view.dart';
import 'package:BodyBuilding/app/modules/navbar/views/navbar_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxBool isLoading = false.obs;
  final box = GetStorage(); // GetStorage untuk penyimpanan lokal

  // Fungsi untuk cek koneksi internet
  Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Registrasi user
  Future<void> registerUser(String email, String password) async {
    try {
      isLoading.value = true;

      // Cek koneksi internet
      if (await isConnected()) {
        // Jika online, lakukan registrasi ke Firebase
        await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        Get.snackbar('Success', 'Registration successful',
            backgroundColor: Colors.green);
        Get.off(LoginView()); // Navigate to Login page
      } else {
        // Jika offline, simpan data ke GetStorage
        box.write('offlineRegister', {'email': email, 'password': password});
        Get.snackbar(
          'Offline',
          'No internet connection. Data saved locally.',
          backgroundColor: Colors.orange,
        );
      }
    } catch (error) {
      Get.snackbar('Error', 'Registration failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Login user
  Future<void> loginUser(String email, String password) async {
    try {
      isLoading.value = true;

      // Cek koneksi internet
      if (await isConnected()) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Hapus data lokal jika ada
        if (box.hasData('offlineRegister')) {
          box.remove('offlineRegister');
        }

        Get.snackbar('Success', 'Login successful',
            backgroundColor: Colors.green);
        Get.off(NavbarView());
      } else {
        // Simpan data login ke lokal jika offline
        box.write('offlineLogin', {'email': email, 'password': password});
        Get.snackbar(
          'Offline',
          'No internet connection. Data saved locally.',
          backgroundColor: Colors.orange,
        );
      }
    } catch (error) {
      Get.snackbar('Error', 'Login failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }

  // Upload data lokal ke Firebase
  Future<void> uploadOfflineData() async {
    if (await isConnected()) {
      if (box.hasData('offlineRegister')) {
        final data = box.read('offlineRegister');
        await _auth.createUserWithEmailAndPassword(
          email: data['email'],
          password: data['password'],
        );
        box.remove('offlineRegister');
        Get.snackbar('Success', 'Offline registration uploaded',
            backgroundColor: Colors.green);
      }

      if (box.hasData('offlineLogin')) {
        final data = box.read('offlineLogin');
        await _auth.signInWithEmailAndPassword(
          email: data['email'],
          password: data['password'],
        );
        box.remove('offlineLogin');
        Get.snackbar('Success', 'Offline login uploaded',
            backgroundColor: Colors.green);
        Get.off(NavbarView());
      }
    }
  }

  Future<void> logoutUser() async {
    try {
      isLoading.value = true;
      await _auth.signOut();
      Get.snackbar('Success', 'Logout successful',
          backgroundColor: Colors.green);
      Get.off(LoginView());
    } catch (error) {
      Get.snackbar('Error', 'Logout failed: $error',
          backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
