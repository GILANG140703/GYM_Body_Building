import 'package:BodyBuilding/app/modules/profil/bindings/profil_binding.dart';

import 'app/modules/connection/bindings/connection_binding.dart';

class DependencyInjection {
  static void init() {
    ConnectionBinding().dependencies();
  }
}
