import 'package:flutter/material.dart';
import 'package:flutter_application_prak/app/modules/home/views/home_view.dart';
import 'package:flutter_application_prak/app/modules/latihan/views/latihan_view.dart';
import 'package:flutter_application_prak/app/modules/login/controllers/login_controller.dart';
import 'package:flutter_application_prak/app/modules/navbar/views/navbar_view.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_login/flutter_login.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

const users = {};

class LoginView extends StatelessWidget {
  AuthController auth = Get.put(AuthController());
  Duration get loginTime => const Duration(milliseconds: 1000);

  Future<String?> _authUser(LoginData data) {
    auth.loginUser(data.name, data.password);
    debugPrint('Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(data.name)) {
        return 'User not exists';
      }
      if (users[data.name] != data.password) {
        return 'Password does not match';
      }
      return Future.value(null);
    });
  }

  Future<String?> _signupUser(SignupData data) {
    auth.registerUser(data.name!, data.password!);
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) {
      return Future.value(null);
    });
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      return Future.value(null);
    });
  }

  @override
  Widget build(BuildContext context) {
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
        pageColorLight: Colors.lightBlue[100], // Background warna biru muda
        primaryColor: Colors.lightBlue, // Warna utama
      ),
    );
  }
}
