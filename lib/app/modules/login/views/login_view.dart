import 'package:flutter/material.dart';
import 'package:flutter_application_prak/app/modules/navbar/views/navbar_view.dart';
import 'package:flutter_application_prak/app/modules/login/controllers/login_controller.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  AuthController auth = Get.put(AuthController());

  Duration get loginTime => const Duration(milliseconds: 1000);

  Future<String?> _authUser(LoginData data) {
    auth.loginUser(data.name, data.password);
    return Future.delayed(loginTime).then((_) => null);
  }

  Future<String?> _signupUser(SignupData data) {
    auth.registerUser(data.name!, data.password!);
    return Future.delayed(loginTime).then((_) => null);
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      return 'User not exists';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Cek dan upload data offline saat aplikasi dimulai
    WidgetsBinding.instance.addPostFrameCallback((_) {
      auth.uploadOfflineData();
    });

    return FlutterLogin(
      logo: const AssetImage('assets/Sign.png'),
      onLogin: _authUser,
      onSignup: _signupUser,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const NavbarView(),
        ));
      },
      onRecoverPassword: _recoverPassword,
      theme: LoginTheme(
        pageColorLight: Colors.lightBlue[100],
        primaryColor: Colors.lightBlue,
      ),
    );
  }
}
