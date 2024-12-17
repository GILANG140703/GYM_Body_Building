import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class ProfilController extends GetxController {
  var toDoList = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadToDoList();
  }

  // Add a To-Do item
  void addToDo(String task) async {
    toDoList.add(task);
    // Save to local storage
    await _saveToDoListLocally();
    // Check if the device is online
    bool isOnline = await _checkInternetConnection();
    if (isOnline) {
      // Sync with Firebase if online
      await _syncToDoListWithFirebase();
    }
  }

  // Delete a To-Do item
  void deleteToDoAt(int index) async {
    toDoList.removeAt(index);
    // Save updated list to local storage
    await _saveToDoListLocally();
    // Check if the device is online
    bool isOnline = await _checkInternetConnection();
    if (isOnline) {
      // Sync with Firebase if online
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

  // Navigate to location view
  void goToLocationView() {
    Get.toNamed('/location');
  }

  // Load To-Do list from SharedPreferences
  Future<void> _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? savedToDoList = prefs.getStringList('toDoList');
    if (savedToDoList != null) {
      toDoList.assignAll(savedToDoList);
    }
  }

  // Save To-Do list to SharedPreferences
  Future<void> _saveToDoListLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('toDoList', toDoList);
  }

  // Sync To-Do list with Firebase
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
            // Add new task if not found
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

  // Check if the device is online
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }
}
