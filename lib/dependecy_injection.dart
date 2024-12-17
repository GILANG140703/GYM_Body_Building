import 'app/modules/connection/bindings/connection_binding.dart';

class DependencyInjection {
  static void init() {
    // Tambahkan semua bindings atau dependencies yang dibutuhkan di sini
    ConnectionBinding().dependencies();
  }
}
