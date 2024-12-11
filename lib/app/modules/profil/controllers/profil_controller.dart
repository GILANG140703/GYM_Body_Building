import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilController extends GetxController {
  var toDoList = <String>[].obs;

  void addToDo(String task) => toDoList.add(task);

  void deleteToDoAt(int index) => toDoList.removeAt(index);

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
}
