import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ProfilController extends GetxController {
  var toDoList = <String>[].obs;
  final RxBool isConnected = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToDoList();

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((results) {
      final result = results.first;
      _handleConnectivityChange(result); // Handle the connectivity change
    });

    // Sync local data (if any)
    _syncLocalData();
  }

  void addToDo(String task) async {
    toDoList.add(task);
    await _saveToDoListLocally();
    bool isOnline = await _checkInternetConnection();
    if (isOnline) {
      await _syncToDoListWithFirebase();
    }
  }

  void deleteToDoAt(int index) async {
    toDoList.removeAt(index);
    await _saveToDoListLocally();
    bool isOnline = await _checkInternetConnection();
    if (isOnline) {
      await _syncToDoListWithFirebase();
    }
  }

  // Logout the user
  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Kesalahan Logout', 'Gagal untuk logout: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void goToLocationView() {
    Get.toNamed('/location');
  }

  Future<void> _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedToDoList = prefs.getStringList('toDoList');
    if (savedToDoList != null) {
      toDoList.assignAll(savedToDoList);
    }
  }

  Future<void> _saveToDoListLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('toDoList', toDoList);
  }

  Future<void> _syncToDoListWithFirebase() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final firestore = FirebaseFirestore.instance;
        for (var task in toDoList) {
          // Check if task already exists in Firestore
          final existingTask = await firestore
              .collection('To-Do List')
              .where('task', isEqualTo: task)
              .where('userEmail', isEqualTo: user.email)
              .get();

          if (existingTask.docs.isEmpty) {
            await firestore.collection('To-Do List').add({
              'task': task,
              'userEmail': user.email,
            });
          }
        }
        Get.snackbar(
            'Sync Sukses', 'To-Do list berhasil disinkronkan dengan Firebase',
            snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar(
          'Kesalahan Sync', 'Gagal untuk menyinkronkan dengan Firebase: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }


  // Handle connectivity change
  void _handleConnectivityChange(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
    if (isConnected.value) {
      Get.snackbar('Online', 'You are now online. Syncing data...',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
      _syncToDoListWithFirebase();
    } else {
      Get.snackbar('Offline', 'You are offline. Data saved locally.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // Check if the device is online

  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Sync local data if there is any
  Future<void> _syncLocalData() async {
    bool isOnline = await _checkInternetConnection();
    if (isOnline) {
      await _syncToDoListWithFirebase();
    }
  }
}
